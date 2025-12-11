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

namespace Ekanayake_Printers_RMS.Main_User_Controls.Manager_User_Control
{
    public partial class Employee_User_Control : UserControl
    {
        public Employee_User_Control()
        {
            InitializeComponent();
        }
        SqlConnection conn = new SqlConnection(@"Data Source=LAPTOP-2956U5GC\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");

        private void btnCreate_Click(object sender, EventArgs e)
        {
            // Validate required fields
            if (string.IsNullOrWhiteSpace(textBox9.Text) || comboBox1.SelectedIndex < 0)
            {
                MessageBox.Show("Please enter User ID and select Employee Type.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            // Validate User ID is a number
            if (!int.TryParse(textBox9.Text, out int userID))
            {
                MessageBox.Show("Please enter a valid numeric User ID.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string employeeType;
            int positionID, occID;

            positionID = comboBox1.SelectedIndex;
            employeeType = GetUserType(positionID);
            occID = setOccupationIndex(positionID);

            try
            {
                conn.Open();

                // First, check if the userID exists in userTable
                SqlCommand checkUser = new SqlCommand("SELECT COUNT(*) FROM userTable WHERE userID = @userID", conn);
                checkUser.Parameters.AddWithValue("@userID", userID);
                int userExists = (int)checkUser.ExecuteScalar();

                if (userExists == 0)
                {
                    MessageBox.Show($"User ID {userID} does not exist in the user table. Please create the user account first.", "User Not Found", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                // Check if employee record already exists for this userID
                SqlCommand checkEmployee = new SqlCommand("SELECT COUNT(*) FROM employeeTable WHERE userID = @userID", conn);
                checkEmployee.Parameters.AddWithValue("@userID", userID);
                int employeeExists = (int)checkEmployee.ExecuteScalar();

                if (employeeExists > 0)
                {
                    MessageBox.Show($"Employee record already exists for User ID {userID}. Please update the existing record instead.", "Duplicate Employee", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // Update the userTable with positionIndex
                SqlCommand cmd2 = new SqlCommand("UPDATE userTable SET positionIndex=@positionIndex WHERE userID=@userID", conn);
                cmd2.Parameters.AddWithValue("@positionIndex", occID);
                cmd2.Parameters.AddWithValue("@userID", userID);
                int j = cmd2.ExecuteNonQuery();

                // Then, insert into employeeTable (employeeID is IDENTITY, so we don't include it)
                SqlCommand cmd = new SqlCommand("INSERT INTO employeeTable(userID, employeeType, positionIndex, status) VALUES (@userID, @employeeType, @positionIndex, 'Active')", conn);
                cmd.Parameters.AddWithValue("@userID", userID);
                cmd.Parameters.AddWithValue("@employeeType", employeeType);
                cmd.Parameters.AddWithValue("@positionIndex", occID);
                int i = cmd.ExecuteNonQuery();

                if (i > 0 && j > 0)
                {
                    MessageBox.Show("Employee record created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // Clear form or refresh data if needed
                    textBox9.Clear();
                    comboBox1.SelectedIndex = -1;
                }
                else
                {
                    MessageBox.Show("Failed to save employee data. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
        }
        private string GetUserType(int positionID)
        {
            switch (positionID)
            {
                
                case 0: return "Manager";
                case 1: return "Accountant";
                case 2: return "Cashier";
                case 3: return "Site Engineer";
                case 4: return "Stock Manager";
                case 5: return "Worker";
                default: return "Unknown";
            }
        }
        private int setOccupationIndex(int positionId)
        {
            switch (positionId)
            {

                case 0: return 1;
                case 1: return 2;
                case 2: return 3;
                case 3: return 4;
                case 4: return 5;
                case 5: return 6;
                default: return 0;
            }

        }

        private void btnclear_Click(object sender, EventArgs e)
        {
            textBox2.Clear();
            comboBox1.Items.Clear();
            
        }

        SqlConnection con = new SqlConnection(@"Data Source=LAPTOP-2956U5GC\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
        SqlDataAdapter da;

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
   
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                if (textBox11.Text is null)
                {
                    if(comboBox2.SelectedIndex == -1)
                    {
                        MessageBox.Show("Enter Value For Both NIC and Employee Type");
                    }
                    else
                    {
                        MessageBox.Show("Enter Proper Value For NIC");
                    }
                }
                else if(comboBox2.SelectedIndex == -1)
                {
                    if(textBox11.Text is null)
                    {
                        MessageBox.Show("Enter Value For Both NIC and Employee Type");
                    }
                    else
                    {
                        MessageBox.Show("Enter Proper Value For Employee Type");
                    }
                }
                else
                {
                    con.Open();
                    
                    string query = @"SELECT e.employeeID, e.userID, e.employeeType, e.department,
                           u.fullName, u.NIC, u.email, u.userAddress, u.tel, u.dob, u.createdDate
                    FROM employeeTable e
                    INNER JOIN userTable u ON e.userID = u.userID
                    WHERE e.employeeType = @employeeType AND u.NIC = @nic";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@employeeType", GetUserType2(comboBox2.SelectedIndex));
                        cmd.Parameters.AddWithValue("@nic", textBox11.Text);
                        
                        using (SqlDataAdapter command = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            command.Fill(dt);
                            dataGridView1.DataSource = dt;
                        }
                    }
                }

            }
            catch (Exception ee)
            {
                MessageBox.Show($"Error searching: {ee.Message}", "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            textBox11.Clear();
            comboBox2.Items.Clear();
        }
        private void ClearAllText(Control control)
        {
            foreach (Control c in control.Controls)
            {
                if (c is TextBox)
                {
                    ((TextBox)c).Clear();
                }
                else if (c is ComboBox)
                {
                    ((ComboBox)c).SelectedIndex = -1;
                }
                else if (c is RichTextBox)
                {
                    ((RichTextBox)c).Clear();
                }
                else if (c is MaskedTextBox)
                {
                    ((MaskedTextBox)c).Clear();
                }
                else if (c is NumericUpDown)
                {
                    ((NumericUpDown)c).Value = 0;
                }
                else if (c is DateTimePicker)
                {
                    ((DateTimePicker)c).Value = DateTime.Now;
                }
                else if (c is GroupBox || c is Panel || c is TabPage)
                {
                    ClearAllText(c); // Recursively clear controls in contained controls
                }
            }
        }

        // Call this method passing your form instance to clear all text
        private void ClearFormText()
        {
            ClearAllText(this);
        }
        private string GetUserType2(int positionID)
        {
            switch (positionID)
            {
                
                case 0: return "Manager";
                case 1: return "Accountant";
                case 2: return "Cashier";
                case 3: return "Site Engineer";
                case 4: return "Stock Manager";
                case 5: return "Worker";
                default: return "Unknown";
            }
        }

        private void Employee_User_Control_Load(object sender, EventArgs e)
        {

        }
    }
}
