package com.akwad.jocards





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


import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding





import com.telpo.tps550.api.printer.ThermalPrinter;
import com.telpo.tps550.api.printer.UsbThermalPrinter;
import com.telpo.tps550.api.util.StringUtil;
import com.telpo.tps550.api.util.SystemUtil;
import com.efikas.flutter_telpo.USBPrinter;
import android.widget.Toast;
import android.util.Log;

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity()  {

    private lateinit var channel : MethodChannel
    private lateinit var activity:Activity
    private lateinit var context: Context
    private lateinit var appPluginBinding: FlutterPlugin.FlutterPluginBinding;

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


   override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (call.method == "connect") {
                        if (!_isConnected) {

                            try {

                                this.registerReceiver(printReceive, pIntentFilter);
                                _isConnected = true;

                                result.success("Connnect")
                            } catch (e: Exception) {
                                Toast.makeText(this, e.toString(), Toast.LENGTH_LONG).show()
                                result.error("printError", e.toString(), null)
                            }
                        }
                    } else if (call.method == "isConnected") {
                        result.success(_isConnected);
                    } else if (call.method == "printDocument") {
                        documentDetails = call.argument("details") ?: ArrayList();
                        USBPrinter(this).printText(documentDetails, result);

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
    }



    companion object {
        private const val CHANNEL = "com.efikas.flutter_telpo/printer"
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