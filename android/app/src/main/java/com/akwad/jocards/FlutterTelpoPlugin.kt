package com.efikas.flutter_telpo

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.BatteryManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


import com.telpo.tps550.api.printer.ThermalPrinter;
import com.telpo.tps550.api.printer.UsbThermalPrinter;
import com.telpo.tps550.api.util.StringUtil;
import com.telpo.tps550.api.util.SystemUtil;
import com.efikas.flutter_telpo.USBPrinter;
import android.widget.Toast;
import android.util.Log;


/** FlutterTelpoPlugin */
class FlutterTelpoPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
    private lateinit var activity:Activity
    private lateinit var context: Context
    private lateinit var appPluginBinding: FlutterPlugin.FlutterPluginBinding;

  private val CHANNEL = "com.efikas.flutter_telpo/printer"
  private var LowBattery = false
  private var _isConnected = false;
  private var printText: String ?= null;
  private var fontSize: Int ?= 2;
  private var walkLength: Int ?= null;
  private var position: Int ?= null;
  private var imageHeight: Int ?= null;
  private var imageWidth: Int ?= null;
  private var documentDetails: MutableList<Map<String, Any>> = ArrayList();
  private val pIntentFilter = IntentFilter();


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
      this.context = flutterPluginBinding.applicationContext
      this.appPluginBinding = flutterPluginBinding;


    pIntentFilter.addAction(Intent.ACTION_BATTERY_CHANGED);
    pIntentFilter.addAction("android.intent.action.BATTERY_CAPACITY_EVENT");
  }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "com.efikas.flutter_telpo/printer")
            channel.setMethodCallHandler(FlutterTelpoPlugin())
            System.out.println("got Here");
        }
    }

    override fun onDetachedFromActivity() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }
    override fun onDetachedFromActivityForConfigChanges() {}

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "connect") {
        if (!_isConnected) {

            try {

                this.context.registerReceiver(printReceive, pIntentFilter);
                _isConnected = true;

                result.success(null)
            } catch (e: Exception) {
                Toast.makeText(activity, e.toString(), Toast.LENGTH_LONG).show()
                result.error("printError", e.toString(), null)
            }
        }
    } else if (call.method == "isConnected") {
        result.success(_isConnected);
    } else if (call.method == "printDocument") {
        documentDetails = call.argument("details") ?: ArrayList();

    } else if (call.method == "disconnect") {
        if (_isConnected) {
            this.context.unregisterReceiver(printReceive);
            _isConnected = false;
        }
    }
    else {
        result.notImplemented()
    }
}

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
      this.context.unregisterReceiver(printReceive)
    channel.setMethodCallHandler(null)
  }

   private val printReceive: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action: String? = intent.getAction()
            if (action == Intent.ACTION_BATTERY_CHANGED) {
                val status: Int = intent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_NOT_CHARGING)
                val level: Int = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0)
                val scale: Int = intent.getIntExtra(BatteryManager.EXTRA_SCALE, 0)
                //TPS390 can not print,while in low battery,whether is charging or not charging
                LowBattery = if (SystemUtil.getDeviceType() == StringUtil.DeviceModelEnum.TPS390.ordinal) {
                    if (level * 5 <= scale) {
                        true
                    } else {
                        false
                    }
                } else {
                    if (status != BatteryManager.BATTERY_STATUS_CHARGING) {
                        if (level * 5 <= scale) {
                            true
                        } else {
                            false
                        }
                    } else {
                        false
                    }
                }
            } else if (action == "android.intent.action.BATTERY_CAPACITY_EVENT") {
                val status: Int = intent.getIntExtra("action", 0)
                val level: Int = intent.getIntExtra("level", 0)
                LowBattery = if (status == 0) {
                    if (level < 1) {
                        true
                    } else {
                        false
                    }
                } else {
                    false
                }
            }
        }
    }
}
