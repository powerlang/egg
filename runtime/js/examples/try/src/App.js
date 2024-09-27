import React, { Component } from "react";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import IDE from "./Webside/src/components/IDE";
import { HashRouter as Router, Routes, Route } from "react-router-dom";
import { DialogProvider } from "./Webside/src/components/dialogs/index";
import EggBackend from "./EggBackend";

class App extends Component {
	constructor(props) {
		super(props);
		this.theme = createTheme({
			palette: {
				mode: "dark",
				primary: {
					main: "#00000",
				},
				text: {
					primary: "#aaaaaa",
					secondary: "#00000",
				},
				background: {
					main: "#1f1f1f",
					default: "#1f1f1f",
				},
			},
		});
		this.backend = new EggBackend("local", "guest");
	}

	render() {
		return (
			<ThemeProvider theme={this.theme}>
				<CssBaseline />
				<DialogProvider>
					<div
						sx={{
							display: "flex",
						}}
					>
						<Router>
							<Routes>
								<Route
									path="/"
									exact
									element={<IDE backend={this.backend} />}
								/>
							</Routes>
						</Router>
					</div>
				</DialogProvider>
			</ThemeProvider>
		);
	}
}

export default App;
