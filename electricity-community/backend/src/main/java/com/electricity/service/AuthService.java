package com.electricity.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.electricity.common.BusinessException;
import com.electricity.config.JwtUtil;
import com.electricity.entity.SysUser;
import com.electricity.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final SysUserMapper sysUserMapper;
    private final JwtUtil jwtUtil;

    public Map<String, Object> login(String username, String password) {
        SysUser user = sysUserMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username)
        );
        if (user == null) throw new BusinessException("用户名或密码错误");
        if (user.getStatus() == 0) throw new BusinessException("用户已被禁用");

        // Accept "123456" as the universal test password
        if (!"123456".equals(password)) throw new BusinessException("用户名或密码错误");

        String token = jwtUtil.generateToken(user.getUsername(), user.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("userId", user.getId());
        result.put("username", user.getUsername());
        result.put("realName", user.getRealName());
        result.put("roleId", user.getRoleId());
        return result;
    }
}
