// dummy PowertalkEvaluatorError, will be removed soon (TM)

let PowertalkEvaluatorError = class extends Error {
	constructor(description, context) {
		super(description);
		this.context = context;
	}

	static signal_on_(description, context) {
		throw new this(description, context);
	}
};

export default PowertalkEvaluatorError;
