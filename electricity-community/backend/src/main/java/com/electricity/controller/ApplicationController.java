package com.electricity.controller;

import com.electricity.common.PageResult;
import com.electricity.common.Result;
import com.electricity.entity.*;
import com.electricity.service.ApplicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/application")
@RequiredArgsConstructor
public class ApplicationController {

    private final ApplicationService applicationService;

    @PostMapping
    public Result<ApplicationInfo> create(@RequestBody Map<String, Object> body) {
        ApplicationInfo app = parseApp(body);
        CustomerInfo customer = parseCustomer(body);
        List<ElectricalEquipment> equipment = parseEquipment(body);
        Long userId = getUserId(body);
        String userName = getUserName(body);
        return Result.ok(applicationService.createApplication(app, customer, equipment, userId, userName));
    }

    @GetMapping("/list")
    public Result<PageResult<ApplicationInfo>> list(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String processStatus,
            @RequestParam(required = false) String keyword) {
        return Result.ok(applicationService.listApplications(pageNum, pageSize, processStatus, keyword));
    }

    @GetMapping("/{id}")
    public Result<ApplicationInfo> detail(@PathVariable Long id) {
        return Result.ok(applicationService.getApplicationDetail(id));
    }

    @GetMapping("/{id}/customer")
    public Result<CustomerInfo> customerInfo(@PathVariable Long id) {
        return Result.ok(applicationService.getCustomerInfo(id));
    }

    @GetMapping("/{id}/equipment")
    public Result<List<ElectricalEquipment>> equipment(@PathVariable Long id) {
        return Result.ok(applicationService.getEquipmentList(id));
    }

    @GetMapping("/{id}/process-history")
    public Result<List<ProcessRecord>> processHistory(@PathVariable Long id) {
        return Result.ok(applicationService.getProcessHistory(id));
    }

    @PostMapping("/{id}/submit")
    public Result<Void> submit(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Long userId = getUserId(body);
        String userName = getUserName(body);
        Boolean hasProject = (Boolean) body.getOrDefault("hasProject", false);
        Boolean skipDispatch = (Boolean) body.getOrDefault("skipDispatch", false);
        applicationService.submitApplication(id, userId, userName,
                hasProject != null && hasProject, skipDispatch != null && skipDispatch);
        return Result.ok();
    }

    @GetMapping("/my-tasks")
    public Result<PageResult<ApplicationInfo>> myTasks(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam String processStatus) {
        return Result.ok(applicationService.listApplications(pageNum, pageSize, processStatus, null));
    }

    // Helper parsing methods (simplified - in production use proper DTOs with Jackson)
    @SuppressWarnings("unchecked")
    private ApplicationInfo parseApp(Map<String, Object> body) {
        Map<String, Object> appMap = (Map<String, Object>) body.get("application");
        if (appMap == null) return new ApplicationInfo();
        ApplicationInfo app = new ApplicationInfo();
        app.setBusinessType((String) appMap.get("businessType"));
        app.setCustomerName((String) appMap.get("customerName"));
        app.setDistrict((String) appMap.get("district"));
        app.setElectricityAddress((String) appMap.get("electricityAddress"));
        app.setContactPerson((String) appMap.get("contactPerson"));
        app.setContactPhone((String) appMap.get("contactPhone"));
        app.setCertType((String) appMap.get("certType"));
        app.setCertNo((String) appMap.get("certNo"));
        app.setElectricityCategory((String) appMap.get("electricityCategory"));
        app.setCapacity(appMap.get("capacity") != null ? new java.math.BigDecimal(appMap.get("capacity").toString()) : null);
        app.setIndustryCategory((String) appMap.get("industryCategory"));
        app.setLoadNature((String) appMap.get("loadNature"));
        app.setPowerSupplyUnit((String) appMap.get("powerSupplyUnit"));
        app.setHouseholdCount(appMap.get("householdCount") != null ? Integer.parseInt(appMap.get("householdCount").toString()) : null);
        app.setRemark((String) appMap.get("remark"));
        app.setIsIntercity(appMap.get("isIntercity") != null ? Integer.parseInt(appMap.get("isIntercity").toString()) : 0);
        app.setIntercityLocation((String) appMap.get("intercityLocation"));
        return app;
    }

    @SuppressWarnings("unchecked")
    private CustomerInfo parseCustomer(Map<String, Object> body) {
        Map<String, Object> cm = (Map<String, Object>) body.get("customer");
        if (cm == null) return null;
        CustomerInfo c = new CustomerInfo();
        c.setCustomerName((String) cm.get("customerName"));
        c.setCertType((String) cm.get("certType"));
        c.setCertNo((String) cm.get("certNo"));
        c.setLegalRepresentative((String) cm.get("legalRepresentative"));
        c.setAddress((String) cm.get("address"));
        c.setContactPerson((String) cm.get("contactPerson"));
        c.setContactPhone((String) cm.get("contactPhone"));
        c.setBusinessLicenseNo((String) cm.get("businessLicenseNo"));
        c.setOrganizationCode((String) cm.get("organizationCode"));
        c.setCustomerType((String) cm.get("customerType"));
        return c;
    }

    @SuppressWarnings("unchecked")
    private List<ElectricalEquipment> parseEquipment(Map<String, Object> body) {
        List<Map<String, Object>> eqList = (List<Map<String, Object>>) body.get("equipment");
        if (eqList == null) return null;
        return eqList.stream().map(eq -> {
            ElectricalEquipment e = new ElectricalEquipment();
            e.setEquipmentName((String) eq.get("equipmentName"));
            e.setEquipmentType((String) eq.get("equipmentType"));
            e.setQuantity(Integer.parseInt(eq.get("quantity").toString()));
            e.setUnitCapacity(new java.math.BigDecimal(eq.get("unitCapacity").toString()));
            e.setTotalCapacity(new java.math.BigDecimal(eq.get("totalCapacity").toString()));
            e.setVoltageLevel((String) eq.get("voltageLevel"));
            e.setPhaseType((String) eq.get("phaseType"));
            return e;
        }).toList();
    }

    private Long getUserId(Map<String, Object> body) {
        Object v = body.get("operatorId");
        return v != null ? Long.parseLong(v.toString()) : 2L;
    }

    private String getUserName(Map<String, Object> body) {
        Object v = body.get("operatorName");
        return v != null ? v.toString() : "系统用户";
    }
}
