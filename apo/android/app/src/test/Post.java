package service;

import android.os.AsyncTask;
import android.util.Pair;
import android.widget.TextView;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

class Post extends AsyncTask<TextView, Integer, Long> {
    protected Long doInBackground(TextView... urls) {
        try

        {
            URL url = new URL("http://a24.a18.113.219/api");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            //conn.setReadTimeout(10000);
            //conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            //conn.setDoInput(true);
            conn.setDoOutput(true);

            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write( "box-tag-select-0-0-0-0" );
            wr.flush();

            // Get the server response

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line = null;

            // Read Server Response
            while((line = reader.readLine()) != null)
            {
                // Append server response in string
                sb.append(line + "\n");
            }


            String text = sb.toString();

            //urlConnection.setDoOutput(true);
            //conn.setChunkedStreamingMode(0);

            OutputStream out = new BufferedOutputStream(conn.getOutputStream());
            //writeStream(out);


            //readStream(in);

            List<Pair<String, String>> params = new ArrayList<>();
            params.add(new Pair<>("data", "box-tag-select-0-0-0-0"));
            //params.add(new Pair<>("password", password));

            //List<NameValuePair> params = new ArrayList<NameValuePair>();
            //params.add(new BasicNameValuePair("firstParam", paramValue1));
            //params.add(new BasicNameValuePair("secondParam", paramValue2));
            //params.add(new BasicNameValuePair("thirdParam", paramValue3));

            //OutputStream os = conn.getOutputStream();
            BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(out, "UTF-8"));

            //URLEncoder.encode(pair.getName(), "UTF-a8")
            writer.write( "box-tag-select-0-0-0-0");
            //writer.flush();
            //writer.close();
            //out.close();

            //conn.connect();
            InputStream in = new BufferedInputStream(conn.getInputStream());
            byte[] contents = new byte[1024];

            int bytesRead = 0;
            String strFileContents = "";
            while((bytesRead = in.read(contents)) != -1) {
                strFileContents += new String(contents, 0, bytesRead);
            }
            String temp = conn.getContent().toString();
            urls[0].setText("sent response...");
            //urls[0].setText(conn.getResponseMessage());
            //texter.setText(conn.getResponseMessage());

        } catch (java.io.IOException ex) {
            String tmp = ex.getMessage();
            String tmp2 = "temp";
        }
        catch (Exception ex) {
            String tmp = ex.getMessage();
            String tmp2 = "temp";
        }

        long returnSize = 0;
        return returnSize;
    }

    protected void onProgressUpdate(Integer... progress) {
        //setProgressPercent(progress[0]);
    }

    protected void onPostExecute(Long result) {
        //showDialog("Downloaded " + result + " bytes");
    }
}


package service;

import android.util.Pair;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONException;
import org.json.JSONObject;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by v-masebo on a8/30/2018.
 */


public class Requestor {

    public void setText(final TextView texter) {
        texter.setText("Sending response...");
    }


    public void sendRequest(RequestQueue queue, final TextView texter) {

        try {
            String url = "http://a24.a18.113.219/api";
            JSONObject obj = new JSONObject();
            JSONObject obj2 = new JSONObject("box-tag-select-0-0-0-0");
            obj.put("data", "box-tag-select-0-0-0-0");
            //JSONObject json = JSONObject("box-tag-select-0-0-0-0");

            JsonObjectRequest jsObjRequest = new JsonObjectRequest(Request.Method.POST, url, obj2, new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject response) {
// TODO Auto-generated method stub
                    texter.setText("Response => " + response.toString());
                    //findViewById(R.id.progressBar1).setVisibility(View.GONE);
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    texter.setText(error.getMessage());
// TODO Auto-generated method stub
                }
            });

            //queue.add(jsObjRequest);
        } catch (JSONException ex) {
        }

        //HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
       // try {



        try

        {
            URL url = new URL("http://a24.a18.113.219/api");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(10000);
            conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);

            //urlConnection.setDoOutput(true);
            conn.setChunkedStreamingMode(0);

            OutputStream out = new BufferedOutputStream(conn.getOutputStream());
            //writeStream(out);

            InputStream in = new BufferedInputStream(conn.getInputStream());
            //readStream(in);

            List<Pair<String, String>> params = new ArrayList<>();
            params.add(new Pair<>("data", "box-tag-select-0-0-0-0"));
            //params.add(new Pair<>("password", password));

            //List<NameValuePair> params = new ArrayList<NameValuePair>();
            //params.add(new BasicNameValuePair("firstParam", paramValue1));
            //params.add(new BasicNameValuePair("secondParam", paramValue2));
            //params.add(new BasicNameValuePair("thirdParam", paramValue3));

            //OutputStream os = conn.getOutputStream();
            BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(out, "UTF-8"));

            //URLEncoder.encode(pair.getName(), "UTF-a8")
            writer.write( "box-tag-select-0-0-0-0");
            writer.flush();
            writer.close();
            out.close();

            conn.connect();

            texter.setText(conn.getResponseMessage());
        } catch (java.io.IOException ex) {
            String tmp = ex.getMessage();
            String tmp2 = "temp";
        }
        catch (Exception ex) {
            String tmp = ex.getMessage();
            String tmp2 = "temp";
        }



    }


}
