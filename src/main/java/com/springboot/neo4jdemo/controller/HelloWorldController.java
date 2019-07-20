package com.springboot.neo4jdemo.controller;


import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping(value="/controller")
public class HelloWorldController {

    @RequestMapping(value = "/hello")
    public String hello() {
        log.info("hello world");
        return "Hello World";
    }
}
