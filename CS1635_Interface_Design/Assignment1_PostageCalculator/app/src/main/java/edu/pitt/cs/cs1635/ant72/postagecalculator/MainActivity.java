package edu.pitt.cs.cs1635.ant72.postagecalculator;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Button;
import android.widget.Spinner;
import android.text.TextWatcher;
import android.text.Editable;

public class MainActivity extends AppCompatActivity {

    private EditText input_field;
    private TextView result_field;
    private Button calc_button;
    private Spinner package_spinner;
    private Double weight;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        input_field = (EditText) findViewById(R.id.edit_message);
        result_field = (TextView) findViewById(R.id.result_view);
        calc_button = (Button) findViewById(R.id.calc_button);
        package_spinner = (Spinner) findViewById(R.id.spinner1);


        input_field.addTextChangedListener(new TextWatcher() {

            @Override
            public void afterTextChanged(Editable s) {

            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after){

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                try {
                    weight = Double.parseDouble(input_field.getText().toString());
                    if ((weight <= 0) || (weight > 13)) {
                        result_field.setText(R.string.invalid_input);
                        calc_button.setEnabled(false);
                    } else {
                        result_field.setText(R.string.calculated_cost);
                        calc_button.setEnabled(true);


                    }
                } catch(NumberFormatException e){
                    result_field.setText(R.string.invalid_input);
                    calc_button.setEnabled(false);
                }
            }
        });
    }

    /** Called when the user clicks Calculate button */
    public void calculateCost(View view){
        String type = package_spinner.getSelectedItem().toString();

        if(type.equals("Letter")){
            if(weight<=1){
                result_field.setText("$0.49");
            }else if(weight<=2){
                result_field.setText("$0.70");
            }else if(weight<=3){
                result_field.setText("$0.91");
            }else if(weight<=3.5){
                result_field.setText("$1.12");
            }else{
                result_field.setText(R.string.letter_oversize);
            }
        }else if(type.equals("Large envelope")){
            if(weight<=1){
                result_field.setText("$0.98");
            }else if(weight<=2){
                result_field.setText("$1.19");
            }else if(weight<=3){
                result_field.setText("$1.40");
            }else if(weight<=4){
                result_field.setText("$1.61");
            }else if(weight<=5){
                result_field.setText("$1.82");
            }else if(weight<=6){
                result_field.setText("$2.03");
            }else if(weight<=7){
                result_field.setText("$2.24");
            }else if(weight<=8){
                result_field.setText("$2.45");
            }else if(weight<=9){
                result_field.setText("$2.66");
            }else if(weight<=10){
                result_field.setText("$2.87");
            }else if(weight<=11){
                result_field.setText("$3.08");
            }else if(weight<=12){
                result_field.setText("$3.29");
            }else{
                result_field.setText("$3.50");
            }
        }else if(type.equals("Package")){
            if(weight<=1){
                result_field.setText("$2.67");
            }else if(weight<=2){
                result_field.setText("$2.67");
            }else if(weight<=3){
                result_field.setText("$2.67");
            }else if(weight<=4){
                result_field.setText("$2.67");
            }else if(weight<=5){
                result_field.setText("$2.85");
            }else if(weight<=6){
                result_field.setText("$3.03");
            }else if(weight<=7){
                result_field.setText("$3.21");
            }else if(weight<=8){
                result_field.setText("$3.39");
            }else if(weight<=9){
                result_field.setText("$3.57");
            }else if(weight<=10){
                result_field.setText("$3.75");
            }else if(weight<=11){
                result_field.setText("$3.93");
            }else if(weight<=12){
                result_field.setText("$4.11");
            }else{
                result_field.setText("$4.29");
            }
        }
    }
}
