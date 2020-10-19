package com.mohanjava.kanbanboard.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MyErrorController implements ErrorController {
	@RequestMapping("/error")
	public String handleError() {
		//TODO
		return "error";
	}

	@Override
	public String getErrorPath() {
		//TODO
		return null;
	}
}
