package com.toyo.kintai.controller.utilities;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


/**
 * Created by  on 2024/12/11.
 */
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer{
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/WEB-INF/css/");
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/WEB-INF/js/");
        registry.addResourceHandler("/img/**")
                .addResourceLocations("/WEB-INF/img/");
        registry.addResourceHandler("/tld/**")
                .addResourceLocations("/WEB-INF/tld/");
        registry.addResourceHandler("/lib/**")
                .addResourceLocations("/WEB-INF/lib/");
    }
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/pages/"); // JSPの基準パス
        resolver.setSuffix(".jsp");           // 拡張子
        return resolver;
    }

}
