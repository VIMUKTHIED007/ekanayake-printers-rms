using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ekanayake_Printers_RMS.Sub_UserControl
{
    public partial class Customer_Register_Form : Form
    {
        public Customer_Register_Form()
        {
            InitializeComponent();
        }
        SqlConnection con;
        SqlCommand cmd;

        private void txtPwd_TextChanged(object sender, EventArgs e)
        {

        }

        private void Customer_Register_Form_Load(object sender, EventArgs e)
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            // Validation
            if (string.IsNullOrWhiteSpace(textBox3.Text))
            {
                MessageBox.Show("Please enter first name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(textBox4.Text))
            {
                MessageBox.Show("Please enter last name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (comboBox1.SelectedIndex < 0)
            {
                MessageBox.Show("Please select customer type.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(textBox7.Text) || !long.TryParse(textBox7.Text, out long telValue))
            {
                MessageBox.Show("Please enter a valid telephone number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            String customerType = "";
            if (comboBox1.SelectedIndex == 0)
            {
                customerType = "Regular Customer";
            }
            else if (comboBox1.SelectedIndex == 1)
            {
                customerType = "Loyalty Customer";
            }
            else
            {
                customerType = "Other";
            }

            String firstName = textBox3.Text.Trim();
            String lastName = textBox4.Text.Trim();
            String email = string.IsNullOrWhiteSpace(textBox5.Text) ? null : textBox5.Text.Trim();
            long tel = telValue;
            String city = string.IsNullOrWhiteSpace(textBox8.Text) ? null : textBox8.Text.Trim();
            String nic = string.IsNullOrWhiteSpace(textBox9.Text) ? null : textBox9.Text.Trim();
            String address = string.IsNullOrWhiteSpace(textBox10.Text) ? null : textBox10.Text.Trim();
            String location = string.IsNullOrWhiteSpace(textBox1.Text) ? null : textBox1.Text.Trim();
            DateTime dob = dateTimePicker1.Value;
            String gender = "";

            if (radioButton4.Checked == true)
            {
                gender = "Male";
            }
            else if (radioButton5.Checked == true)
            {
                gender = "Female";
            }
            else if (radioButton6.Checked == true)
            {
                gender = "Prefer Not To Say";
            }
            else
            {
                gender = null;
            }

            try
            {
                con.Open();
                // Fixed: customerID is IDENTITY, so we don't include it in INSERT
                // Fixed: Use explicit column names and proper parameter names
                // Fixed: regDate and status have defaults, so we don't need to include them
                cmd = new SqlCommand(@"INSERT INTO customer 
                    (customerType, firstName, lastName, email, tel, city, nic, customerAddress, customerLocation, dob, gender, status) 
                    VALUES 
                    (@customerType, @firstName, @lastName, @email, @tel, @city, @nic, @address, @location, @dob, @gender, 'Active')", con);
                
                cmd.Parameters.AddWithValue("@customerType", customerType);
                cmd.Parameters.AddWithValue("@firstName", firstName);
                cmd.Parameters.AddWithValue("@lastName", lastName);
                cmd.Parameters.AddWithValue("@email", email ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@tel", tel);
                cmd.Parameters.AddWithValue("@city", city ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@nic", nic ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@address", address ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@location", location ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@dob", dob);
                cmd.Parameters.AddWithValue("@gender", gender ?? (object)DBNull.Value);

                int rowsAffected = cmd.ExecuteNonQuery();
                
                if (rowsAffected > 0)
                {
                    MessageBox.Show("Customer registered successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // Clear form after successful registration
                    btnclear_Click(sender, e);
                }
                else
                {
                    MessageBox.Show("Customer registration failed. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                con.Close();
                cmd.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error registering customer: " + ex.Message + "\n\nDetails: " + ex.InnerException?.Message, 
                    "Registration Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }

        private void btnclear_Click(object sender, EventArgs e)
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            textBox4.Clear();
            textBox5.Clear();
            textBox7.Clear();
            textBox8.Clear();
            textBox9.Clear();
            textBox10.Clear();

        }

        private void panel14_Paint(object sender, PaintEventArgs e)
        {

        }
    }
}
