using Ekanayake_Printers_RMS.Sub_UserControl;
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

namespace Ekanayake_Printers_RMS.Main_User_Controls.Worker_UC
{
    public partial class Add_Customer : UserControl
    {
        public Add_Customer()
        {
            InitializeComponent();
        }

        SqlConnection con;
        SqlCommand cmd;

        private void btnregister_Click(object sender, EventArgs e)
        {
            
            Customer_Register_Form obj = new Customer_Register_Form();
            obj.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            Customer_Update_Form obj = new Customer_Update_Form();
            obj.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            User_Status_Form obj = new User_Status_Form();
            obj.Show();
        }

        private void txt_cus_ID_TextChanged(object sender, EventArgs e)
        {

        }

        private void Add_Customer_Load(object sender, EventArgs e)
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
        }

        private void btncusSearch_Click(object sender, EventArgs e)
        {
            // Validation: Check if NIC is entered
            if (string.IsNullOrWhiteSpace(textBox2.Text))
            {
                MessageBox.Show("Please enter NIC number to search.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                con.Open();
                // Fixed: Search by NIC only (no need for Tel)
                // Fixed: Select all customer details
                cmd = new SqlCommand(@"SELECT 
                    customerID, 
                    customerType, 
                    firstName, 
                    lastName, 
                    email, 
                    tel, 
                    city, 
                    nic, 
                    customerAddress, 
                    customerLocation, 
                    dob, 
                    regDate, 
                    gender, 
                    status 
                    FROM customer 
                    WHERE nic = @Nic", con);
                cmd.Parameters.AddWithValue("@Nic", textBox2.Text.Trim());

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Display all customer details
                    txt_cus_ID.Text = reader["customerID"] != DBNull.Value ? reader["customerID"].ToString() : "";
                    textBox9.Text = reader["customerType"] != DBNull.Value ? reader["customerType"].ToString() : "";
                    txt_fname.Text = reader["firstName"] != DBNull.Value ? reader["firstName"].ToString() : "";
                    txt_lname.Text = reader["lastName"] != DBNull.Value ? reader["lastName"].ToString() : "";
                    txt_email.Text = reader["email"] != DBNull.Value ? reader["email"].ToString() : "";
                    txt_tel.Text = reader["tel"] != DBNull.Value ? reader["tel"].ToString() : "";
                    txt_city.Text = reader["city"] != DBNull.Value ? reader["city"].ToString() : "";
                    txt_nic.Text = reader["nic"] != DBNull.Value ? reader["nic"].ToString() : "";
                    textBox6.Text = reader["customerAddress"] != DBNull.Value ? reader["customerAddress"].ToString() : "";
                    txtPwd.Text = reader["customerLocation"] != DBNull.Value ? reader["customerLocation"].ToString() : "";
                    
                    // Handle date fields
                    if (reader["dob"] != DBNull.Value && reader["dob"] != null)
                    {
                        if (DateTime.TryParse(reader["dob"].ToString(), out DateTime dobValue))
                        {
                            textBox1.Text = dobValue.ToString("yyyy-MM-dd");
                        }
                    }
                    else
                    {
                        textBox1.Text = "";
                    }
                    
                    if (reader["regDate"] != DBNull.Value && reader["regDate"] != null)
                    {
                        if (DateTime.TryParse(reader["regDate"].ToString(), out DateTime regDateValue))
                        {
                            textBox4.Text = regDateValue.ToString("yyyy-MM-dd");
                        }
                    }
                    else
                    {
                        textBox4.Text = "";
                    }
                    
                    textBox7.Text = reader["gender"] != DBNull.Value ? reader["gender"].ToString() : "";
                    
                    // Also populate the search result fields
                    textBox8.Text = reader["customerID"] != DBNull.Value ? reader["customerID"].ToString() : "";
                    textBox10.Text = reader["customerType"] != DBNull.Value ? reader["customerType"].ToString() : "";
                    textBox5.Text = reader["firstName"] != DBNull.Value ? reader["firstName"].ToString() : "";
                    
                    MessageBox.Show("Customer found and details loaded!", "Search Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Customer not found with NIC: " + textBox2.Text, "Not Found", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // Clear all fields
                    ClearCustomerFields();
                }

                reader.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error searching customer: " + ex.Message + "\n\nDetails: " + ex.InnerException?.Message, 
                    "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }
        
        private void ClearCustomerFields()
        {
            txt_cus_ID.Clear();
            textBox9.Clear();
            txt_fname.Clear();
            txt_lname.Clear();
            txt_email.Clear();
            txt_tel.Clear();
            txt_city.Clear();
            txt_nic.Clear();
            textBox6.Clear();
            txtPwd.Clear();
            textBox1.Clear();
            textBox4.Clear();
            textBox7.Clear();
            textBox8.Clear();
            textBox10.Clear();
            textBox5.Clear();
        }

        private void btn_Click(object sender, EventArgs e)
        {
            // Validation: Check if NIC is entered
            if (string.IsNullOrWhiteSpace(textBox2.Text))
            {
                MessageBox.Show("Please enter NIC number to search.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                con.Open();
                // Fixed: Search by NIC only, use correct column names
                cmd = new SqlCommand(@"SELECT 
                    customerID, 
                    customerType, 
                    firstName, 
                    lastName, 
                    email, 
                    tel, 
                    city, 
                    nic, 
                    customerAddress, 
                    customerLocation, 
                    dob, 
                    regDate, 
                    gender, 
                    status 
                    FROM customer 
                    WHERE nic = @Nic", con);
                cmd.Parameters.AddWithValue("@Nic", textBox2.Text.Trim());

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Display all customer details with proper null handling
                    txt_cus_ID.Text = reader["customerID"] != DBNull.Value ? reader["customerID"].ToString() : "";
                    textBox9.Text = reader["customerType"] != DBNull.Value ? reader["customerType"].ToString() : "";
                    txt_fname.Text = reader["firstName"] != DBNull.Value ? reader["firstName"].ToString() : "";
                    txt_lname.Text = reader["lastName"] != DBNull.Value ? reader["lastName"].ToString() : "";
                    txt_email.Text = reader["email"] != DBNull.Value ? reader["email"].ToString() : "";
                    txt_tel.Text = reader["tel"] != DBNull.Value ? reader["tel"].ToString() : "";
                    txt_city.Text = reader["city"] != DBNull.Value ? reader["city"].ToString() : "";
                    txt_nic.Text = reader["nic"] != DBNull.Value ? reader["nic"].ToString() : "";
                    // Fixed: Use correct column names (customerAddress, customerLocation)
                    textBox6.Text = reader["customerAddress"] != DBNull.Value ? reader["customerAddress"].ToString() : "";
                    txtPwd.Text = reader["customerLocation"] != DBNull.Value ? reader["customerLocation"].ToString() : "";
                    
                    // Handle date fields
                    if (reader["dob"] != DBNull.Value && reader["dob"] != null)
                    {
                        if (DateTime.TryParse(reader["dob"].ToString(), out DateTime dobValue))
                        {
                            textBox1.Text = dobValue.ToString("yyyy-MM-dd");
                        }
                    }
                    else
                    {
                        textBox1.Text = "";
                    }
                    
                    if (reader["regDate"] != DBNull.Value && reader["regDate"] != null)
                    {
                        if (DateTime.TryParse(reader["regDate"].ToString(), out DateTime regDateValue))
                        {
                            textBox4.Text = regDateValue.ToString("yyyy-MM-dd");
                        }
                    }
                    else
                    {
                        textBox4.Text = "";
                    }
                    
                    textBox7.Text = reader["gender"] != DBNull.Value ? reader["gender"].ToString() : "";
                    
                    MessageBox.Show("Customer details loaded successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Customer not found with NIC: " + textBox2.Text, "Not Found", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    ClearCustomerFields();
                }

                reader.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error searching customer: " + ex.Message + "\n\nDetails: " + ex.InnerException?.Message, 
                    "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }

        // Clear button functionality
        private void button5_Click(object sender, EventArgs e)
        {
            textBox2.Clear();
            textBox3.Clear();
            ClearCustomerFields();
        }

        // Allow searching by pressing Enter in NIC field
        private void textBox2_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true; // Prevent beep sound
                btncusSearch_Click(sender, e);
            }
        }
    }
}
