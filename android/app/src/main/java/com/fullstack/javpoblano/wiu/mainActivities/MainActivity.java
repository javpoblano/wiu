package com.fullstack.javpoblano.wiu.mainActivities;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.telephony.SmsManager;
import android.util.Log;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.fullstack.javpoblano.wiu.AccelerometerListener;
import com.fullstack.javpoblano.wiu.AccelerometerManager;
import com.fullstack.javpoblano.wiu.OnTaskCompleted;
import com.fullstack.javpoblano.wiu.PlogReceiver;
import com.fullstack.javpoblano.wiu.R;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.UiSettings;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener,OnMapReadyCallback,LocationListener,OnTaskCompleted,AccelerometerListener {

    public PlogReceiver pl;
    MapView mapView;
    GoogleMap map;
    private LocationManager locationManager;
    LocationListener locationListener;
    MarkerOptions mo;
    private static final String[] LOCATION_PERMS={
            Manifest.permission.ACCESS_FINE_LOCATION
    };
    private static final int LOCATION_REQUEST=1337+3;
    PolylineOptions rectOptions=null;
    Polyline polyline;
    Boolean tracking = false;
    ImageButton bar1,bar2,bar3;
    RelativeLayout dialog;
    LatLng inicio,fin,actual=new LatLng(19.019590,-98.244890);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        rectOptions = new PolylineOptions();
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        IntentFilter filter = new IntentFilter("android.intent.action.HEADSET_PLUG");


        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        dialog = (RelativeLayout)findViewById(R.id.dialog);
        mapView = (MapView)findViewById(R.id.map);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);

        if (!canAccessLocation()) {
            requestPermissions(LOCATION_PERMS, LOCATION_REQUEST);
        }

        locationListener = this;

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        try
        {
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,1000, 0, locationListener);

        }
        catch (SecurityException x)
        {
            Toast.makeText(getApplicationContext(),x.getMessage(),Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_zonas) {
            // Handle the camera action
        } else if (id == R.id.nav_routes) {

        } else if (id == R.id.nav_mates) {

        } else if (id == R.id.nav_config) {

        } else if (id == R.id.nav_stats) {

        }
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        map = googleMap;
        map.getUiSettings().setZoomControlsEnabled(false);
        map.getUiSettings().setAllGesturesEnabled(false);
        LatLng sydney = new LatLng(19.019590,-98.244890);
        //map.addMarker(new MarkerOptions().position(sydney).title("Reporte").icon(BitmapDescriptorFactory.fromResource(R.drawable.location)));
        //map.addMarker(new MarkerOptions().position(sydney).icon(BitmapDescriptorFactory.fromResource(R.drawable.location)));
        //map.addMarker(new MarkerOptions().position(sydney));
        map.moveCamera(CameraUpdateFactory.newLatLng(sydney));
        CameraPosition camPos = new CameraPosition.Builder()
                .target(sydney)
                .zoom(18)
                .tilt(30)
                .build();
        map.animateCamera(CameraUpdateFactory.newCameraPosition(camPos));
    }

    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    public void onPause()
    {
        super.onPause();
        mapView.onPause();
    }

    @Override
    public void onLocationChanged(Location location) {
        if(map!=null)
        {
            /*LatLng sydney = new LatLng(19.019590,-98.244890);
            mo = new MarkerOptions().position(new LatLng(location.getLatitude(), location.getLongitude()));
            //map.addMarker(new MarkerOptions().position(sydney).icon(BitmapDescriptorFactory.fromResource(R.drawable.location)));
            map.clear();
            map.addMarker(mo);

            CameraPosition camPos = new CameraPosition.Builder()
                    .target(mo.getPosition())
                    .zoom(18)
                    .tilt(30)
                    .build();
            map.animateCamera(CameraUpdateFactory.newCameraPosition(camPos));
            */


            actual=new LatLng(location.getLatitude(),location.getLongitude());
            if(tracking)
            {
                Log.d("Loc1",location.toString());
                track(location);
                Log.d("Loc2", location.toString());
                Log.d("Loc3",tracking.toString());
            }


        }

    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }

    public void onClick(View view)
    {
        int i =view.getId();

        switch (i)
        {
            case R.id.barra_ruta:
                trackingButton();
                break;
            case R.id.barra_seguir:
                activateAlerts();
                break;

        }
    }


    private boolean canAccessLocation() {
        return(hasPermission(Manifest.permission.ACCESS_FINE_LOCATION));
    }

    private boolean hasPermission(String perm) {
        return(PackageManager.PERMISSION_GRANTED==checkSelfPermission(perm));
    }

    public void track(Location location)
    {
        rectOptions.color(Color.BLUE).width(10);
        rectOptions.add(new LatLng(location.getLatitude(), location.getLongitude())); // Closes the polyline.

        // Get back the mutable Polyline
        polyline = map.addPolyline(rectOptions);

        CameraPosition camPos = new CameraPosition.Builder()
                .target(new LatLng(location.getLatitude(),location.getLongitude()))
                .zoom(18)
                .tilt(30)
                .build();
        map.animateCamera(CameraUpdateFactory.newCameraPosition(camPos));

    }

    public void trackingButton()
    {
        if(!tracking)
        {
            rectOptions = new PolylineOptions();
            rectOptions.color(Color.BLUE).width(10);
            Log.d("but","");
            map.clear();
            map.addMarker(new MarkerOptions().position(actual));
            inicio = actual;
            tracking=true;
        }
        else
        {
            fin = actual;
            tracking=false;
            map.addMarker(new MarkerOptions().position(fin));
            //SEND DATA TO API
        }
    }

    public void alert(View view)
    {
        dialog.setVisibility(View.VISIBLE);
    }

    public void cancelAlert(View view)
    {
        dialog.setVisibility(View.GONE);
    }

    public void activateAlerts()
    {
        pl = new PlogReceiver(this);
        IntentFilter filter = new IntentFilter("android.intent.action.HEADSET_PLUG");
        registerReceiver(pl, filter);
        if (AccelerometerManager.isSupported(this)) {

            //Start Accelerometer Listening
            AccelerometerManager.startListening(this);
        }
    }


    @Override
    public void onTaskCompleted() {
        unregisterReceiver(pl);
        Toast.makeText(getApplicationContext(),"ALARMA ENVIADA",Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAccelerationChanged(float x, float y, float z) {

    }

    public void sendSMS() {
        try
        {
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage("5550592953", null, "Javier" + " tiene una emergencia", null, null);
            smsManager.sendTextMessage("5519532777", null, "Javier" + " tiene una emergencia", null, null);
            smsManager.sendTextMessage("5551056594", null, "Javier" + " tiene una emergencia", null, null);
        }
        catch (SecurityException x )
        {
            Log.e("err",x.toString());
        }

    }

    @Override
    public void onShake(float force) {
        try
        {
            sendSMS();
            Uri number = Uri.parse("tel:2221773973");
            Intent callIntent = new Intent(Intent.ACTION_CALL, number);
            callIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(callIntent);
        }
        catch (SecurityException e)
        {
            Toast.makeText(getApplicationContext(),e.toString(),Toast.LENGTH_SHORT).show();
        }
    }
}
