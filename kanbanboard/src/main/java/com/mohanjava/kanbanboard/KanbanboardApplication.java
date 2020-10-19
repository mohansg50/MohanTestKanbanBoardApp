package com.mohanjava.kanbanboard;

import java.util.Arrays;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootConfiguration
@EnableAutoConfiguration
@SpringBootApplication

public class KanbanboardApplication {

	public static void main(String[] args) {
		SpringApplication.run(KanbanboardApplication.class, args);
	}

//	public static void main(String[] args) {
//		ApplicationContext ctx = SpringApplication.run(KanbanboardApplication.class, args);
//
//		String[] beanNames = ctx.getBeanDefinitionNames();
//
//		Arrays.sort(beanNames);
//
//		for (String beanName : beanNames) {
//			System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx>" + beanName);
//		}
//	}
}
