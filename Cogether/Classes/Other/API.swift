//
//  API.swift
//  Cogether
//
//  Created by tongho on 2017/5/24.
//  Copyright © 2017年 tongho. All rights reserved.
//


let commonAPI = "http://114.115.221.206:8088/campus/"  //华为云

let checkPhoneAPI = commonAPI+"user/checkPhone"  //验证手机号接口

let doLoginAPI = commonAPI+"user/doLogin"   //用户名&密码 登录接口

let doRegistAPI = commonAPI+"user/doRegister"  //提交注册信息

let completeUserInfoAPI = commonAPI+"/user/completeUserInfo" //完善个人信息接口

let modifyUserInfoAPI = commonAPI+"/user/modifyUserInfo"    //修改个人信息接口

let getShareRecommendUpdateAPI = commonAPI+"article/getShareRecommend/Update"  //分享帖首页接口

let getShareRecommendLoadMoreAPI = commonAPI+"article/getShareRecommend/LoadMore" //加载更多分享帖

let getArticleDetailsAPI = commonAPI+"article/getArticleDetails" //获取帖子详细信息

let getRecommendUser = commonAPI+"user/getRecommend/Update"  //获取推荐的用户

let getMoreRecommendUser = commonAPI+"user/getRecommend/LoadMore" //获取更多用户











