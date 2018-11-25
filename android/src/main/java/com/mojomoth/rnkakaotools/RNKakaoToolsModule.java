
package com.mojomoth.rnkakaotools;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import com.kakao.kakaolink.v2.KakaoLinkService;
import com.kakao.kakaolink.v2.KakaoLinkResponse;
import com.kakao.message.template.FeedTemplate;
import com.kakao.message.template.LinkObject;
import com.kakao.message.template.ButtonObject;
import com.kakao.message.template.SocialObject;
import com.kakao.message.template.ContentObject;

import com.kakao.network.callback.ResponseCallback;
import com.kakao.network.ErrorResult;

import java.util.Map;
import java.util.HashMap;

public class RNKakaoToolsModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNKakaoToolsModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNKakaoTools";
  }

  @ReactMethod
  public void foo(final Callback callback) {
    callback.invoke();
  }

  @ReactMethod
  public void link(
    String title,
    String buttonText,
    String imageURI,
    String webURL,
    String mobileWebURL,
    String androidExecutionParams,
    String iosExecutionParams,
    final Callback successCallback
  ) {
    FeedTemplate params = FeedTemplate
        .newBuilder(ContentObject.newBuilder(
            title,
            imageURI,
            LinkObject.newBuilder()
                .setWebUrl(webURL)
                .setMobileWebUrl(mobileWebURL)
                .setAndroidExecutionParams(androidExecutionParams)
                .setIosExecutionParams(iosExecutionParams).build())
            .build())
        .addButton(new ButtonObject(
            buttonText,
            LinkObject.newBuilder()
                .setWebUrl(webURL)
                .setMobileWebUrl(mobileWebURL)
                .setAndroidExecutionParams(androidExecutionParams)
                .setIosExecutionParams(iosExecutionParams).build()))
        .build();
    Map<String, String> serverCallbackArgs = new HashMap<String, String>();
    serverCallbackArgs.put("user_id", "${current_user_id}");
    serverCallbackArgs.put("product_id", "${shared_product_id}");

    KakaoLinkService.getInstance().sendDefault(this.getCurrentActivity(), params, serverCallbackArgs,
        new ResponseCallback<KakaoLinkResponse>() {
          @Override
          public void onFailure(ErrorResult errorResult) {
            successCallback.invoke(errorResult.toString());
          }

          @Override
          public void onSuccess(KakaoLinkResponse result) {
            successCallback.invoke(result);
          }
        });
  } 
}