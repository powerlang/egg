
#ifndef _TREECODEDECODER_H_
#define _TREECODEDECODER_H_

#include <map>
#include <vector>
#include <sstream>
#include <iterator>

#include "../Util.h"
#include "../HeapObject.h"

#include "SArgumentBinding.h"
#include "SAssignment.h"
#include "SBlock.h"
#include "SCascade.h"
#include "SCascadeMessage.h"
#include "SDynamicBinding.h"
#include "SFalseBinding.h"
#include "SIdentifier.h"
#include "SLiteral.h"
#include "SMessage.h"
#include "SMethod.h"
#include "SNestedDynamicBinding.h"
#include "SNilBinding.h"
#include "SPragma.h"
#include "SReturn.h"
#include "SSelfBinding.h"
#include "SSuperBinding.h"
#include "STemporaryBinding.h"
#include "STrueBinding.h"

#include "Runtime.h"

namespace Egg {

enum AstBindingTypes {
    DynamicVarId = 14,
    NilId = 1,
    SelfId = 6,
    TrueId = 2,
    PopRid = 51,
    NestedDynamicVarId = 15,
    SuperId = 7,
    TemporaryId = 5,
    ArgumentId = 4,
    PushRid = 50,
    FalseId = 3
};

enum AstNodeTypes {
    AssignmentId = 108,
    BraceId = 107,
    IdentifierId = 103,
    ReturnId = 109,
    MethodId = 101,
    PragmaId = 110,
    MessageId = 105,
    LiteralId = 104,
    BlockId = 102,
    CascadeId = 106
};

class TreecodeDecoder {

	HeapObject *_method;
	std::istringstream _stream;
	Runtime *_runtime;

public:
	SExpression* decodeExpression(auto id)
	{
		switch (id)
		{
			case AstNodeTypes::AssignmentId:		return this->decodeAssignment();
			case AstNodeTypes::BlockId:				return this->decodeBlock();
			case AstNodeTypes::CascadeId:			return this->decodeCascade();
			case AstNodeTypes::LiteralId:			return this->decodeLiteral();
			case AstNodeTypes::IdentifierId:		return this->decodeIdentifier();
			case AstNodeTypes::MessageId:			return this->decodeMessage();
			case AstNodeTypes::ReturnId:			return this->decodeReturn();
			default:								ASSERT(false); return nullptr;
		}
	}

	SBinding* decodeBinding(auto id) {

		switch(id) {
			case AstBindingTypes::NilId:				return new SNilBinding();
			case AstBindingTypes::TrueId:				return new STrueBinding();
			case AstBindingTypes::FalseId:				return new SFalseBinding();
			case AstBindingTypes::SelfId:				return new SSelfBinding();
			case AstBindingTypes::SuperId:				return new SSuperBinding();
			case AstBindingTypes::ArgumentId:			return new SArgumentBinding(this->nextInteger(), this->nextEnvironment());
			case AstBindingTypes::TemporaryId:			return new STemporaryBinding(this->nextInteger(), this->nextEnvironment());
			case AstBindingTypes::DynamicVarId:			return new SDynamicBinding(this->nextSymbol());
			case AstBindingTypes::NestedDynamicVarId:	return new SNestedDynamicBinding(this->nextSymbol());
			default:									ASSERT(false); return nullptr;
		}
	}


	void runtime_(Runtime *aRuntime) {
		this->_runtime = aRuntime;
	}

	SAssignment* decodeAssignment() {
		auto assignees = this->nextExpressionArray();
		auto assignment = new SAssignment(this->nextExpression());
		for (auto identifier: assignees) {
			assignment->assign(dynamic_cast<SIdentifier*>(identifier));
		};
		return assignment;
	}

	SBlock* decodeBlock() {
		auto expression = new SBlock();
		auto inlined = this->nextBoolean();
		if (inlined) {
			expression->inlinedArgs_(this->nextArray());
		} else {
			auto index = this->nextInteger();
			auto block = this->literalAt_(index)->asHeapObject();
			auto code = this->_runtime->newExecutableCodeFor_(block, reinterpret_cast<HeapObject*>(expression));
			this->_runtime->blockExecutableCode_put_(block, (Object*)code);
		
			expression->compiledCode_(block);
			expression->index_(index);
			expression->capturedVariables_(this->nextArray());
		}
		expression->statements_(this->nextExpressionArray());
		return expression;
	}

	SCascade* decodeCascade() {
		auto cascade = new SCascade();
		auto receiver = this->nextExpression();
		auto count = this->nextInteger();

		auto messages = std::vector<SCascadeMessage*>();
		messages.reserve(count);
    	for (int i = 1; i <= count; i++) {
			messages.push_back(this->decodeCascadeMessage(cascade));
		}
		cascade->receiver(receiver);
		cascade->messages(messages);
		return cascade;
	}

	SCascadeMessage* decodeCascadeMessage(SCascade *cascade) {
		auto selector = this->nextSymbol();
		auto _arguments = this->nextExpressionArray();
		return new SCascadeMessage(selector, _arguments, cascade);
	}

	SIdentifier* decodeIdentifier() {
		auto binding = this->decodeBinding(this->nextInteger());
		return new SIdentifier(binding);
	}

	SLiteral* decodeLiteral() {
		auto index = this->nextInteger();
		auto value = index == 0 ? (Object*)this->nextLiteralInteger() : this->literalAt_(index);
		return new SLiteral(index, value);
	}

	SMessage* decodeMessage() {
		auto inlined = this->nextBoolean();
		auto selector = this->nextSymbol();
		auto receiver = this->nextExpression();
		auto _arguments = this->nextExpressionArray();
		return new SMessage(receiver, selector, _arguments, inlined);
	}

	SMethod* decodeMethod() {
		char type;
		this->_stream.get(type);
		if (type != AstNodeTypes::MethodId) {
			error("method treecode expected");
		}
		
		auto node = new SMethod();
		auto next = this->_stream.peek();
		if (next == AstNodeTypes::PragmaId) {
			uint8_t dummy;
			this->_stream >> dummy;
			auto pragma = new SPragma(this->nextSymbolOrNil());
			node->pragma_(pragma);
			return node;
		}
		node->compiledCode_(this->_method);
		node->statements_(this->nextExpressionArray());
		return node;
	}

	SReturn* decodeReturn() {
		auto local = this->nextBoolean();
		auto expression = this->nextExpression();
		return new SReturn(local, expression);
	}

	Object*  literalAt_(auto anInteger) {
		return this->_runtime->method_literalAt_(this->_method, anInteger);
	}

	void method_(auto *aMethod) {
		this->_method = aMethod;
	}

	std::vector<uint8_t> nextArray() {
		auto count = this->nextInteger();
	    std::vector<uint8_t> elements;
		for (int i = 0; i < count; i++)
			elements.push_back(this->nextByte());
		return elements;
	}

	bool nextBoolean() {
		
		return this->nextByte() == 1;
	}

	uint8_t nextByte() {
		uint8_t value;
		this->_stream.read(reinterpret_cast<char*>(&value), sizeof(uint8_t));
		return value;
	}

	int64_t nextEnvironment() {
		auto value = this->nextInteger();
		return value != -2 ? value: 0;
	}

	SExpression* nextExpression() {
		return this->decodeExpression(this->nextByte());
	}

	std::vector<SExpression*> nextExpressionArray() {
		auto count = this->nextInteger();
		std::vector<SExpression*> result;
		result.reserve(count);
    	for (int arg = 1; arg <= count; arg++) 
			result.push_back(this->nextExpression());

		return result;
	}

	int64_t nextInteger() {
		uint8_t value = this->nextByte();
		if (value == 128) {
			int64_t value64;
			this->_stream.read(reinterpret_cast<char*>(&value64), sizeof(int64_t));
			return value64;
		}
		return value < 127 ? value : value-256;
	}

	SmallInteger* nextLiteralInteger() {
		auto value = this->nextInteger();
		return this->_runtime->newInteger_(value);
	}

	HeapObject* nextSymbol() {
		auto index = this->nextInteger();
		return this->literalAt_(index)->asHeapObject();
	}

	HeapObject* nextSymbolOrNil() {
		auto index = this->nextInteger();
		return index != 0 ? this->literalAt_(index)->asHeapObject() : KnownObjects::nil;
	}

	uint64_t nextUnsignedInteger() {
		auto value = this->nextByte();
		return value < 128 ? value : (value-128)+(this->nextUnsignedInteger() << 7);
	}

	void bytes_(const std::string &bytes) {
		this->_stream.str(bytes);
	}

};

} // namespace Egg

#endif // ~ _TREECODEDECODER_H_ ~
