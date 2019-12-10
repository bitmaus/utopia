
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.widget.Toast;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.util.Set;
import java.util.UUID;

Button mainBtn;
BluetoothAdapter bluetoothAdapter;
BluetoothSocket socket;
BluetoothDevice bluetoothDevice;
OutputStream outputStream;
InputStream inputStream;
Thread workerThread;
byte[] readBuffer;
int readBufferPosition;
volatile boolean stopWorker;
String value = "";

bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
try
{
    if(!bluetoothAdapter.isEnabled())
    {
        Intent enableBluetooth = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        startActivityForResult(enableBluetooth, 0);
    }

    Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();

    if(pairedDevices.size() > 0)
    {
        for(BluetoothDevice device : pairedDevices)
        {
            if(device.getName().equals("SP200")) //Note, you will need to change this to match the name of your device
            {
                bluetoothDevice = device;
                break;
            }
        }

        UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB"); //Standard SerialPortService ID
        Method m = bluetoothDevice.getClass().getMethod("createRfcommSocket", new Class[]{int.class});
        socket = (BluetoothSocket) m.invoke(bluetoothDevice, 1);
        bluetoothAdapter.cancelDiscovery();
        socket.connect();
        outputStream = socket.getOutputStream();
        inputStream = socket.getInputStream();
        beginListenForData();
    }
    else
    {
        value+="No Devices found";
        Toast.makeText(this, value, Toast.LENGTH_LONG).show();
        return;
    }
}
catch(Exception ex)
{
    value+=ex.toString()+ "\n" +" InitPrinter \n";
    Toast.makeText(this, value, Toast.LENGTH_LONG).show();
}

try {
    final Handler handler = new Handler();

    // this is the ASCII code for a newline character
    final byte delimiter = 10;

    stopWorker = false;
    readBufferPosition = 0;
    readBuffer = new byte[1024];

    workerThread = new Thread(new Runnable() {
        public void run() {

            while (!Thread.currentThread().isInterrupted() && !stopWorker) {

                try {

                    int bytesAvailable = inputStream.available();

                    if (bytesAvailable > 0) {

                        byte[] packetBytes = new byte[bytesAvailable];
                        inputStream.read(packetBytes);

                        for (int i = 0; i < bytesAvailable; i++) {

                            byte b = packetBytes[i];
                            if (b == delimiter) {

                                byte[] encodedBytes = new byte[readBufferPosition];
                                System.arraycopy(
                                        readBuffer, 0,
                                        encodedBytes, 0,
                                        encodedBytes.length
                                );

                                // specify US-ASCII encoding
                                final String data = new String(encodedBytes, "US-ASCII");
                                readBufferPosition = 0;

                                // tell the user data were sent to bluetooth printer device
                                handler.post(new Runnable() {
                                    public void run() {
                                        Log.d("e", data);
                                    }
                                });

                            } else {
                                readBuffer[readBufferPosition++] = b;
                            }
                        }
                    }

                } catch (IOException ex) {
                    stopWorker = true;
                }

            }
        }
    });

    workerThread.start();

} catch (Exception e) {
    e.printStackTrace();
}

byte[] buffer = txtvalue.getBytes();
byte[] PrintHeader = { (byte) 0xAA, 0x55,2,0 };
PrintHeader[3]=(byte) buffer.length;
InitPrinter();
if(PrintHeader.length>128)
{
    value+="\nValue is more than 128 size\n";
    Toast.makeText(this, value, Toast.LENGTH_LONG).show();
}
else
{
    try
    {

        outputStream.write(txtvalue.getBytes());
        outputStream.close();
        socket.close();
    }
    catch(Exception ex)
    {
        value+=ex.toString()+ "\n" +"Excep IntentPrint \n";
        Toast.makeText(this, value, Toast.LENGTH_LONG).show();
    }
}

<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />


https://github.com/imrankst1221/Thermal-Printer-in-Android/tree/master/ThermalPrinter/app/src/main

https://www.digitalocean.com/community/tutorials/how-to-build-android-roms-on-ubuntu-16-04

package com.treeop.datetime;

import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Toast;

public class CustomOnItemSelectedListener implements OnItemSelectedListener {

    public void onItemSelected(AdapterView<?> parent, View view, int pos,long id) {
        Toast.makeText(parent.getContext(),
                "OnItemSelectedListener : " + parent.getItemAtPosition(pos).toString(),
                Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onNothingSelected(AdapterView<?> arg0) {
        // TODO Auto-generated method stub
    }

}

TextView editText = (TextView) findViewById(R.id.textView);

        TextView editText2 = (TextView) findViewById(R.id.textView2);

        editText2.setText(cYear + " - " + cMonth + " (" + monthName +") - " + cDay + " (" + weekday + ") @ " + cHour2 + ":" + cMinute + " " + mobileTimeZone);

        editText.setText(currentTime.toString());


public void showDatePickerDialog(View v) {
        DialogFragment newFragment = new DatePickerFragment();
        newFragment.show(getSupportFragmentManager(), "datePicker");
    }

    public void showDateTime(View v) {
        //new AlertDialog.Builder(this).create();
        final View dialogView = View.inflate(this, R.layout.date_time_picker, null);
        final AlertDialog alertDialog = new AlertDialog.Builder(this).create();

        //RelativeLayout item = (RelativeLayout)findViewById(R.id.);
        //View child = getLayoutInflater().inflate(R.layout.child, null);
        //item.addView(child);

        dialogView.findViewById(R.id.date_time_set).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                DatePicker datePicker = (DatePicker) dialogView.findViewById(R.id.date_picker);
                TimePicker timePicker = (TimePicker) dialogView.findViewById(R.id.time_picker);

                Calendar calendar = new GregorianCalendar(datePicker.getYear(),
                        datePicker.getMonth(),
                        datePicker.getDayOfMonth(),
                        timePicker.getCurrentHour(),
                        timePicker.getCurrentMinute());

                //time = calendar.getTimeInMillis();
                alertDialog.dismiss();
            }
        });
        alertDialog.setView(dialogView);
        alertDialog.show();
    }

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DisplayMessageActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);



        // add the textview to the linearlayout
        //myLinearLayout.addView(rowTextView);
        setContentView(R.layout.activity_display_message);

        // Get the Intent that started this activity and extract the string
        Intent intent = getIntent();
        String message = intent.getStringExtra(MainActivity2.EXTRA_MESSAGE);

        // Capture the layout's TextView and set the string as its text

        TextView textView = (TextView)findViewById(R.id.textView2);
        textView.setText(message);

        final TextView rowTextView = new TextView(this);
        LinearLayout myLinearLayout = (LinearLayout)findViewById(R.id.linearLayout);
        // set some properties of rowTextView or something
        rowTextView.setText("This is row #");

        myLinearLayout.addView(rowTextView);
    }

    public void sendMessage(View view) {
        final TextView rowTextView = new TextView(this);
        LinearLayout myLinearLayout = (LinearLayout)findViewById(R.id.linearLayout);
        // set some properties of rowTextView or something
        rowTextView.setText("Get item");

        myLinearLayout.addView(rowTextView);
    }
}