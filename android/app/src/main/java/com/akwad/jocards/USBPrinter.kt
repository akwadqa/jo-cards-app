package webview.com.jocards

import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.google.zxing.common.BitMatrix
import android.graphics.Bitmap;
import com.telpo.tps550.api.TelpoException;
import com.telpo.tps550.api.printer.UsbThermalPrinter;
import com.telpo.tps550.api.util.StringUtil;
import com.telpo.tps550.api.util.SystemUtil;
import com.telpo.tps550.api.printer.ThermalPrinter;
import android.graphics.BitmapFactory;
import android.widget.Toast;
import android.util.Log;
import android.R.id.message
import android.os.*
import java.util.*
import java.io.File
import android.app.Activity;
import io.flutter.plugin.common.MethodChannel.Result
import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import io.flutter.embedding.engine.plugins.FlutterPlugin



class USBPrinter {
    private val NOPAPER = 3
    private val LOWBATTERY = 4
    private val PRINTVERSION = 5
    private val PRINTBARCODE = 6
    private val PRINTQRCODE = 7
    private val PRINTPAPERWALK = 8
    private val PRINTCONTENT = 9
    private val CANCELPROMPT = 10
    private val PRINTERR = 11
    private val OVERHEAT = 12
    private val MAKER = 13
    private val PRINTPICTURE = 14
    private val NOBLACKBLOCK = 15
    private var nopaper = false
    private var LowBattery = false
    private var leftDistance = 0
    private var lineDistance = 0
    private var wordFont = 0
    private var printGray = 7
    private var charSpace = 0
    private var fontSize: Int = 2;
    private var textAlignment: Int = UsbThermalPrinter.ALGIN_LEFT;
    private var Result: String? = null
    var mainActivity: Activity? = null
    var mUsbThermalPrinter: UsbThermalPrinter? = null;
    //    private val picturePath: String = Environment.getExternalStorageDirectory().getAbsolutePath() + "/111.bmp"
    private var printVersion: String? = null
    var barcodeStr: String? = null
    var qrcodeStr: String? = null
    var paperWalk = 0
    var printContent: String ?= null
    private var documentDetails: MutableList<Map<String, Any>> = ArrayList();
    private var MAX_LEFT_DISTANCE = 255
    private lateinit var printResult: Result;
    public lateinit var appPluginBinding: FlutterPlugin.FlutterPluginBinding;


    constructor(_mainActivity: Activity) {
        mainActivity = _mainActivity
        mUsbThermalPrinter = UsbThermalPrinter(mainActivity);
    }


    fun printText(details: MutableList<Map<String, Any>>, result: Result) {
       documentDetails = details;
        printResult = result;


        if (LowBattery == true) {
            result.error("LowBattery", "Low battery", null);
            MyHandler().sendMessage(MyHandler().obtainMessage(LOWBATTERY, 1, 0, null))
        } else {
            if (!nopaper) {
                MyHandler().sendMessage(MyHandler().obtainMessage(PRINTCONTENT, 1, 0, null))
            } else {
                result.error("noPaper", "No paper available", null);
//                Toast.makeText(mainActivity, "NO PAPER AVAILABLE", Toast.LENGTH_LONG).show()
            }
        }
    }

    fun setAlignment(alignment: Int): Int {
        when (alignment) {
            0 -> { return UsbThermalPrinter.ALGIN_LEFT}
            1 -> { return UsbThermalPrinter.ALGIN_MIDDLE}
            2 -> { return  UsbThermalPrinter.ALGIN_RIGHT}
            else -> { return  UsbThermalPrinter.ALGIN_LEFT}
        }
    }



    inner class MyHandler : android.os.Handler() {
        override fun handleMessage(msg: android.os.Message) {
            when (msg.what) {
                NOPAPER -> {}
                NOPAPER -> {}
                LOWBATTERY -> {}
                NOBLACKBLOCK -> {}
                PRINTVERSION -> {}
                PRINTBARCODE -> {}
                PRINTBARCODE -> {}
                PRINTQRCODE -> {}
                PRINTQRCODE -> {}
                PRINTPAPERWALK -> {}
                PRINTCONTENT -> contentDocument()
                MAKER -> {}
                PRINTPICTURE -> {}
                CANCELPROMPT -> {}
                OVERHEAT -> {}
            }
        }
    }

    fun contentDocument() {
    mainActivity?.runOnUiThread {
        try {
            // Start printer
            mUsbThermalPrinter?.start(0)
            mUsbThermalPrinter?.reset()

            mUsbThermalPrinter?.setAlgin(textAlignment)
            mUsbThermalPrinter?.setLeftIndent(leftDistance)
            mUsbThermalPrinter?.setLineSpace(lineDistance)
            mUsbThermalPrinter?.setGray(printGray)

            // Print every row
            for (row in documentDetails) {

                // =========================
                // WALK PAPER
                // =========================
                if (row["type"].toString() == "walkPaper") {
                    val step =
                        row["step"].toString().toIntOrNull() ?: 2

                    mUsbThermalPrinter?.walkPaper(step)
                }

                // =========================
                // QR CODE
                // =========================
                if (row["type"].toString() == "qrcode") {

                    val bitmap = CreateCode(
                        row["text"].toString(),
                        BarcodeFormat.QR_CODE,
                        row["width"]
                            .toString()
                            .toIntOrNull() ?: 256,
                        row["height"]
                            .toString()
                            .toIntOrNull() ?: 256
                    )

                    mUsbThermalPrinter?.setAlgin(
                        setAlignment(1)
                    )

                    mUsbThermalPrinter?.printLogo(
                        bitmap,
                        true
                    )
                }

                // =========================
                // IMAGE
                // =========================
                if (row["type"].toString() == "image") {

                    val filePath =
                        appPluginBinding
                            .getFlutterAssets()
                            .getAssetFilePathBySubpath(
                                row["pathUrl"].toString()
                            )

                    val file = File(filePath)

                    if (file.exists()) {
                        mUsbThermalPrinter?.printLogo(
                            BitmapFactory.decodeFile(
                                file.absolutePath
                            ),
                            false
                        )

                        mUsbThermalPrinter?.walkPaper(10)
                    }
                }

                // =========================
                // TEXT
                // =========================
                if (row["type"].toString() == "text") {

                     val text = row["text"]?.toString()


                    if (text.isNullOrEmpty())  {

                        mUsbThermalPrinter?.walkPaper(2)

                    } else {
                        val size = row["fontSize"]
                       ?.toString()
                       ?.toIntOrNull() ?: 11

                      // Font size
                        when (
                            row["fontSize"]
                                ?.toString()
                                ?.toIntOrNull()
                        ) {
                           
                            3 -> {
                                mUsbThermalPrinter?.setTextSize(40)
                            }

                            2 -> {
                                mUsbThermalPrinter?.setTextSize(32)
                            }

                            else -> {
                                mUsbThermalPrinter?.setTextSize(24)
                            }
                        }
                      val isBold = row["bold"] as? Boolean ?: false

                        // Alignment
                        mUsbThermalPrinter?.setAlgin(
                            setAlignment(
                                row["position"]
                                    .toString()
                                    .toIntOrNull() ?: 0
                            )
                        )
                       mUsbThermalPrinter?.setBold(isBold)

                        // Print text
                        mUsbThermalPrinter?.addString(text)
                        mUsbThermalPrinter?.printString()
                        mUsbThermalPrinter?.setBold(false)
                    }
                }
            }

            // =====================================================
            // IMPORTANT
            // =====================================================
            // Give the Telpo printer time to physically flush
            // the final text and paper-walk commands.
            //
            // Without this, the last lines such as:
            //
            // admin jocards
            // Phone:
            // 0770151616
            //
            // can remain in the printer buffer and appear
            // at the beginning of the NEXT print.
            // =====================================================

            Thread.sleep(500)

            // Stop printer only AFTER the buffer has been flushed
            mUsbThermalPrinter?.stop()

            Log.d(
                "USBPrinter",
                "TELPO PRINT COMPLETED"
            )

            // Complete Flutter MethodChannel call
            printResult.success("Print completed")

        } catch (e: Exception) {

            Log.e(
                "USBPrinter",
                "========== TELPO PRINT ERROR ==========",
                e
            )

            Log.e(
                "USBPrinter",
                "Exception class: ${e::class.java.name}"
            )

            Log.e(
                "USBPrinter",
                "Exception message: ${e.message}"
            )

            mainActivity?.runOnUiThread {
                Toast.makeText(
                    mainActivity,
                    "TELPO ERROR: ${e::class.java.simpleName}: ${e.message}",
                    Toast.LENGTH_LONG
                ).show()
            }

            when (e) {

                is com.telpo.tps550.api.printer.NoPaperException -> {

                    nopaper = true

                    printResult.error(
                        "noPaper",
                        "No paper available",
                        e.message
                    )
                }

                is com.telpo.tps550.api.printer.OverHeatException -> {

                    printResult.error(
                        "overHeating",
                        "Device over heating",
                        e.message
                    )
                }

                else -> {

                    printResult.error(
                        "printerError",
                        e.message ?: "Printer Error",
                        Log.getStackTraceString(e)
                    )
                }
            }

        } finally {

            if (nopaper) {

                MyHandler().sendMessage(
                    MyHandler().obtainMessage(
                        NOPAPER,
                        1,
                        0,
                        null
                    )
                )

                mainActivity?.runOnUiThread {
                    Toast.makeText(
                        mainActivity,
                        "NO PAPER AVAILABLE",
                        Toast.LENGTH_LONG
                    ).show()
                }

                nopaper = false
            }
        }
    }
}


    /**
     *
     * @param str
     * @param type
     * AZTEC, CODABAR, CODE_39, CODE_93, CODE_128, DATA_MATRIX,
     * EAN_8, EAN_13, ITF, MAXICODE, PDF_417, QR_CODE, RSS_14,
     * RSS_EXPANDED, UPC_A, UPC_E, UPC_EAN_EXTENSION;
     * @param bmpWidth
     * @param bmpHeight
     */
    @kotlin.jvm.Throws(WriterException::class)
    fun CreateCode(str: String?, type: com.google.zxing.BarcodeFormat?, bmpWidth: Int, bmpHeight: Int): Bitmap {
        val matrix: BitMatrix = MultiFormatWriter().encode(str, type, bmpWidth, bmpHeight)
        val width: Int = matrix.getWidth()
        val height: Int = matrix.getHeight()
        val pixels = IntArray(width * height)
        for (y in 0 until height) {
            for (x in 0 until width) {
                if (matrix.get(x, y)) {
                    pixels[y * width + x] = -0x1000000
                } else {
                    pixels[y * width + x] = -0x1
                }
            }
        }
        val bitmap: Bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height)
        return bitmap
    }
}