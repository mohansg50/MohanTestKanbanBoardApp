package com.mohanjava.kanbanboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import com.mohanjava.kanbanboard.model.TaskMaster;
import com.mohanjava.kanbanboard.repository.TaskMasterRepository;
import com.mohanjava.kanbanboard.util.MyConstants;

@Controller
public class HomeController {

	@Autowired
	private TaskMasterRepository repository;

	@GetMapping({ "/", "/index" })

	public ModelAndView showWelcomePage(final Model model, final RedirectAttributes redirectAttributes) {
		TaskMaster taskMaster = new TaskMaster();
		model.addAttribute("taskMaster", taskMaster);
		return new ModelAndView("index");
	}

	@RequestMapping(value = "/processTaskMasterDropAction", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
	public ModelAndView updateTaskMaster(final Model model, @RequestBody TaskMaster taskMaster) {

		int taskMasterID = taskMaster.getTaskMasterID();

		TaskMaster dbTaskMaster = repository.findById(taskMasterID).orElse(null);

		dbTaskMaster.setTaskCategory(taskMaster.getTaskCategory());
		repository.saveAndFlush(dbTaskMaster);

		RedirectView redirectView = new RedirectView("index", true);
		return new ModelAndView(redirectView);

	}

	@RequestMapping(value = "/createTaskMaster", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
	public ModelAndView createTaskMaster(final Model model, @RequestBody TaskMaster taskMaster) {

		taskMaster.setTaskCategory(MyConstants.TASK_CAT_BACKLOG);
		taskMaster.setRecordStatus(MyConstants.RECORD_STATUS_ACTIVE);
		TaskMaster taskMaster2 = repository.save(taskMaster);

		// TODO - test newly created object
		// model.addAttribute("message", "Done");

		RedirectView redirectView = new RedirectView("index", true);
		return new ModelAndView(redirectView);
	}

	@RequestMapping(value = "getTaskList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	public List<TaskMaster> getTaskList2() {
		// List<TaskMaster> list = repository.findAll();
		List<TaskMaster> list = repository.findAllActiveTasks();
		return list;
	}

	@RequestMapping(value = "/deleteTask", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
	public ModelAndView deleteTaskMaster(final Model model, @RequestBody TaskMaster taskMaster) {

		TaskMaster dbTaskMaster = repository.findById(taskMaster.getTaskMasterID()).orElse(null);

		dbTaskMaster.setRecordStatus(MyConstants.RECORD_STATUS_DELETED);
		repository.saveAndFlush(dbTaskMaster);

		RedirectView redirectView = new RedirectView("index", true);
		return new ModelAndView(redirectView);
	}

	@RequestMapping(value = "/moveTask", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
	public ModelAndView moveTaskMaster(final Model model, @RequestBody TaskMaster taskMaster) {

		TaskMaster dbTaskMaster = repository.findById(taskMaster.getTaskMasterID()).orElse(null);

		dbTaskMaster.setTaskCategory(taskMaster.getTaskCategory());
		repository.saveAndFlush(dbTaskMaster);

		RedirectView redirectView = new RedirectView("index", true);
		return new ModelAndView(redirectView);
	}

}
