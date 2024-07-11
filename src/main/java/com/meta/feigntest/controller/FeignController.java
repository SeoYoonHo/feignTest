package com.meta.feigntest.controller;

import com.meta.feigntest.dto.TestData;
import com.meta.feigntest.feign.OpenFeignClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class FeignController {
    private final OpenFeignClient openFeignClient;

    @PostMapping("test")
    public String getTest1(@RequestBody TestData testData) {
        String data = testData.getDummyData();
//        log.info(data);

        return "test";
    }

    @PostMapping("feignTest")
    public String getTest2(@RequestBody TestData testData) {
        int cnt = testData.getCnt();

        int successCnt = 0;

        for (int i = 0; i < cnt; i++) {
            try {
                openFeignClient.testFeign(testData);
                successCnt++;
            } catch (Exception e) {
                log.error(e.getMessage());
            }
        }

        return "test success count: " + successCnt;
    }
}
