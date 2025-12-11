using Ekanayake_Printers_RMS.Sub_UserControl;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing.Text;
using System.Windows.Forms;

namespace Ekanayake_Printers_RMS.Main_User_Controls
{
    public partial class UserAccount_Panel_Form : UserControl
    {
        public UserAccount_Panel_Form()
        {
            InitializeComponent();
            LoadData();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            this.Hide();
            Customer_Register_Form obj = new Customer_Register_Form();
            obj.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Hide();
            Customer_Update_Form obj = new Customer_Update_Form();
            obj.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Hide();
            User_Status_Form obj = new User_Status_Form();
            obj.Show();
        }

        public SqlConnection con;
        private SqlCommand cmd;
        private SqlDataAdapter da;

        private void UserAccount_Panel_Form_Load(object sender, EventArgs e)
        {
           
            
        }

        private void LoadData()
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            try
            {
                con.Open();
                da = new SqlDataAdapter("SELECT * FROM userTable WHERE NIC NOT LIKE '0%'", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dataGridView1.DataSource = dt;
            }
            catch (Exception ex)
            {
                // // // MessageBox.Show(ee.Message);
            }
            finally
            {
                con.Close();
            }
        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            // Validate required fields
            if (string.IsNullOrWhiteSpace(textBox6.Text) || string.IsNullOrWhiteSpace(textBox9.Text) || 
                string.IsNullOrWhiteSpace(textBox7.Text) || comboBox1.SelectedIndex < 0)
            {
                MessageBox.Show("Please fill in all required fields: Full Name, Username, Password, and Position.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            
            string userType, fullName, userName, email, nic, userAddress, pwd;
            long tel;
            int positionID;
            DateTime Dob;

            fullName = textBox6.Text.Trim();
            positionID = comboBox1.SelectedIndex;
            userType = GetUserType(positionID);
            nic = string.IsNullOrWhiteSpace(textBox12.Text) ? null : textBox12.Text.Trim();
            // Safely convert tel - handle empty or invalid values
            if (string.IsNullOrWhiteSpace(textBox13.Text))
            {
                tel = 0;
            }
            else
            {
                if (!long.TryParse(textBox13.Text, out tel))
                {
                    MessageBox.Show("Please enter a valid telephone number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }
            }
            email = string.IsNullOrWhiteSpace(textBox1.Text) ? null : textBox1.Text.Trim();
            userAddress = string.IsNullOrWhiteSpace(textBox14.Text) ? null : textBox14.Text.Trim();
            Dob = dateTimePicker4.Value;
            userName = textBox9.Text.Trim();
            pwd = textBox7.Text.Trim();

            try
            {
                con.Open();
                
                // Check if username already exists
                SqlCommand checkUser = new SqlCommand("SELECT COUNT(*) FROM userTable WHERE username = @username", con);
                checkUser.Parameters.AddWithValue("@username", userName);
                object result = checkUser.ExecuteScalar();
                int userExists = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
                
                if (userExists > 0)
                {
                    MessageBox.Show("Username already exists. Please choose a different username.", "Duplicate Username", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    con.Close();
                    return;
                }

                // Insert into userTable - userID is IDENTITY, so we don't include it
                // Insert all fields in one statement
                cmd = new SqlCommand(@"INSERT INTO userTable (fullName, NIC, email, userAddress, tel, dob, username, userPassword, positionIndex, userType, status) 
                                      VALUES (@fullName, @nic, @email, @userAddress, @tel, @dob, @username, @userPassword, @positionIndex, @userType, 'Active')", con);
                
                cmd.Parameters.AddWithValue("@fullName", fullName);
                cmd.Parameters.AddWithValue("@nic", nic ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@email", email ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@userAddress", userAddress ?? (object)DBNull.Value);
                // Handle tel - use DBNull if 0, otherwise use the value
                cmd.Parameters.AddWithValue("@tel", tel == 0 ? (object)DBNull.Value : tel);
                cmd.Parameters.AddWithValue("@dob", Dob);
                cmd.Parameters.AddWithValue("@username", userName);
                cmd.Parameters.AddWithValue("@userPassword", pwd);
                cmd.Parameters.AddWithValue("@positionIndex", positionID);
                cmd.Parameters.AddWithValue("@userType", userType);

                int rowsAffected = cmd.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    // Get the newly created userID
                    object identityResult = new SqlCommand("SELECT SCOPE_IDENTITY()", con).ExecuteScalar();
                    if (identityResult == null || identityResult == DBNull.Value)
                    {
                        throw new Exception("Failed to retrieve the newly created user ID.");
                    }
                    int newUserID = Convert.ToInt32(identityResult);

                    // If positionID is not 0 (not Administrator), create employee record
                    if (positionID > 0)
                    {
                        // Insert into employeeTable - employeeID is IDENTITY, so we don't include it
                        SqlCommand cmdEmployee = new SqlCommand(@"INSERT INTO employeeTable (userID, employeeType, positionIndex, status) 
                                                                  VALUES (@userID, @employeeType, @positionIndex, 'Active')", con);
                        cmdEmployee.Parameters.AddWithValue("@userID", newUserID);
                        cmdEmployee.Parameters.AddWithValue("@employeeType", userType);
                        cmdEmployee.Parameters.AddWithValue("@positionIndex", positionID);
                        cmdEmployee.ExecuteNonQuery();

                        // Insert into appropriate role table based on positionIndex
                        InsertIntoRoleTable(con, newUserID, positionID);
                    }

                    MessageBox.Show("User account created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    
                    // Clear form fields
                    ClearFormFields();
                    
                    // Refresh the data grid
                    LoadData();
                }
                else
                {
                    MessageBox.Show("Failed to create user account. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (SqlException sqlEx)
            {
                MessageBox.Show($"Database error: {sqlEx.Message}", "Database Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }

        private string GetUserType(int positionID)
        {
            switch (positionID)
            {
                case 0: return "Administrator";
                case 1: return "Manager";
                case 2: return "Accountant";
                case 3: return "Cashier";
                case 4: return "Site Engineer";
                case 5: return "Stock Manager";
                case 6: return "Worker";
                default: return "Unknown";
            }
        }

        private void InsertIntoRoleTable(SqlConnection connection, int userID, int positionIndex)
        {
            try
            {
                SqlCommand cmdRole = null;
                
                switch (positionIndex)
                {
                    case 1: // Manager
                        cmdRole = new SqlCommand("INSERT INTO managerTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                    case 2: // Accountant
                        cmdRole = new SqlCommand("INSERT INTO accountantTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                    case 3: // Cashier
                        cmdRole = new SqlCommand("INSERT INTO cashierTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                    case 4: // Site Engineer
                        cmdRole = new SqlCommand("INSERT INTO siteEngineerTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                    case 5: // Stock Manager
                        cmdRole = new SqlCommand("INSERT INTO stockManagerTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                    case 6: // Worker
                        cmdRole = new SqlCommand("INSERT INTO workerTable (userID, positionIndex) VALUES (@userID, @positionIndex)", connection);
                        break;
                }

                if (cmdRole != null)
                {
                    cmdRole.Parameters.AddWithValue("@userID", userID);
                    cmdRole.Parameters.AddWithValue("@positionIndex", positionIndex);
                    cmdRole.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // Log error but don't fail the entire operation
                Debug.WriteLine($"Error inserting into role table: {ex.Message}");
            }
        }

        private void ClearFormFields()
        {
            textBox4.Clear();
            textBox6.Clear();
            textBox12.Clear();
            textBox13.Clear();
            textBox1.Clear();
            textBox14.Clear();
            textBox9.Clear();
            textBox7.Clear();
            textBox11.Clear();
            comboBox1.SelectedIndex = -1;
            dateTimePicker4.Value = DateTime.Now;
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            ClearFormFields();
        }

        private void btncusSearch_Click(object sender, EventArgs e)
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            string nic = textBox2.Text;
            string tel = textBox3.Text;

            try
            {
                string userid;
                con.Open();
                string query = "SELECT userID,fullName FROM userTable WHERE NIC = @nic AND tel = @tel";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@nic", nic);
                cmd.Parameters.AddWithValue("@tel", tel);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Safely handle DBNull values
                        object userIDObj = reader["userID"];
                        textBox8.Text = userIDObj != null && userIDObj != DBNull.Value ? userIDObj.ToString() : "";
                        userid = userIDObj != null && userIDObj != DBNull.Value ? userIDObj.ToString() : "";
                       
                        object fullNameObj = reader["fullName"];
                        textBox5.Text = fullNameObj != null && fullNameObj != DBNull.Value ? fullNameObj.ToString() : "";
                       
                        try
                        {
                            Debug.WriteLine("UserID is : " + userid);
                            SqlCommand cmd2 = new SqlCommand("SELECT * FROM employeeTable WHERE userID =@uid", con);
                            cmd2.Parameters.AddWithValue("@uid", userid);
                            
                            using (SqlDataReader reader2 = cmd2.ExecuteReader())
                            {
                                if (reader2.Read())
                                {
                                    // Safely handle DBNull values - GetValue(1) is userID column
                                    object employeeUserID = reader2.GetValue(1);
                                    if (employeeUserID != null && employeeUserID != DBNull.Value)
                                    {
                                        textBox10.Text = employeeUserID.ToString();
                                        Debug.WriteLine("User Occupation Found : " + employeeUserID.ToString());
                                    }
                                }
                            }
                        }
                        catch (Exception exe)
                        {
                            Debug.WriteLine($"Error reading employee data: {exe.Message}");
                        }
                        
                    }
                    else
                    {
                        MessageBox.Show("No matching records found.");
                    }
                }
            }
            catch (Exception ex)
            {
                // // // MessageBox.Show(ee.Message);
            }
            finally
            {
                con.Close();
            }
        }

        private void btnShow_Click(object sender, EventArgs e)
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            string nic = textBox2.Text;
            string tel = textBox3.Text;

            try
            {
                con.Open();
                da = new SqlDataAdapter("SELECT * FROM userTable WHERE nic = @nic AND tel = @tel", con);
                da.SelectCommand.Parameters.AddWithValue("@nic", nic);
                da.SelectCommand.Parameters.AddWithValue("@tel", tel);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dataGridView1.DataSource = dt;
            }
            catch (Exception ex)
            {
                // // // MessageBox.Show(ee.Message);
            }
            finally
            {
                con.Close();
            }
        }

        private void label29_Click(object sender, EventArgs e)
        {

        }

        private void textBox12_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
