package com.meta.feigntest.feign;

import com.meta.feigntest.dto.TestData;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "FeignTestClient", url = "${url.targetUrl}")
public interface OpenFeignClient {

    @PostMapping("/api/v1/test")
    public String testFeign(TestData testData);
}
