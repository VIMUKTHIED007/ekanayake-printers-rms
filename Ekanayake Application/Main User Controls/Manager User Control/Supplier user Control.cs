using Microsoft.Reporting.Map.WebForms.BingMaps;
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

namespace Ekanayake_Printers_RMS.Main_User_Controls
{
    public partial class Supplier_user_Control : UserControl
    {
        public Supplier_user_Control()
        {
            InitializeComponent();
            getGrid1();
        }
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        SqlDataAdapter dasales;

        private void Supplier_user_Control_Load(object sender, EventArgs e)
        {
            con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
        }
        private void btnCreate_Click(object sender, EventArgs e)
        {
            String supplierType, firstName, address, email, company;
            long tel;
            int positionID;

            // Validation
            if (string.IsNullOrWhiteSpace(textBox3.Text))
            {
                MessageBox.Show("Please enter supplier name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(textBox17.Text))
            {
                MessageBox.Show("Please enter company name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (listBox2.SelectedIndex < 0)
            {
                MessageBox.Show("Please select supplier type.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrWhiteSpace(textBox7.Text) || !long.TryParse(textBox7.Text, out tel))
            {
                MessageBox.Show("Please enter a valid telephone number.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                positionID = listBox2.SelectedIndex;
                supplierType = GetUserType(positionID);
                firstName = textBox3.Text;
                address = textBox10.Text ?? "";
                email = textBox5.Text ?? "";
                company = textBox17.Text;

                con.Open();
                // Remove supID from INSERT - it's an IDENTITY column (auto-generated)
                cmd = new SqlCommand("INSERT INTO SUPPLIERS (supName, email, tel, company, userAddress, supplierType, status) VALUES (@supName, @email, @tel, @company, @userAddress, @supplierType, 'Active')", con);
                cmd.Parameters.AddWithValue("@supName", firstName);
                cmd.Parameters.AddWithValue("@email", string.IsNullOrWhiteSpace(email) ? (object)DBNull.Value : email);
                cmd.Parameters.AddWithValue("@tel", tel);
                cmd.Parameters.AddWithValue("@company", company);
                cmd.Parameters.AddWithValue("@userAddress", string.IsNullOrWhiteSpace(address) ? (object)DBNull.Value : address);
                cmd.Parameters.AddWithValue("@supplierType", supplierType);

                int i = cmd.ExecuteNonQuery();

                if (i == 1)
                {
                    MessageBox.Show("Data Save Successfully !!!! New Supplier Added..!!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // Clear form
                    btnclear_Click(sender, e);
                    // Refresh grid
                    getGrid1();
                }
                else
                {
                    MessageBox.Show("Data Could not been Saved", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                con.Close();
                cmd.Dispose();
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error Found !!!!! " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }

        private void btnclear_Click(object sender, EventArgs e)
        {
            textBox2.Clear();
            listBox2.Items.Clear();
            textBox3.Clear();
            textBox10.Clear();
            textBox5.Clear();
            textBox7.Clear();
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                con.Open();
                // Fixed query: Join supplierSales with supplier on supplierID, and with itemTable on itemID
                // Corrected table names and join conditions
                dasales = new SqlDataAdapter(@"SELECT 
                    ss.salesID,
                    s.supplierID,
                    s.supplierName,
                    s.company,
                    ss.SupplierNIC,
                    i.itemID,
                    i.modelID,
                    i.details AS itemDescription,
                    i.brand,
                    i.category,
                    ss.SalesQTY,
                    ss.unitPrice,
                    ss.totalAmount,
                    ss.salesDate
                FROM supplierSales ss
                INNER JOIN supplier s ON ss.supplierID = s.supplierID
                INNER JOIN itemTable i ON ss.itemID = i.itemID
                ORDER BY ss.salesDate DESC", con);
                DataTable dt = new DataTable();
                dasales.Fill(dt);
                dataGridView1.DataSource = dt;
                con.Close();
            }
            catch( Exception ex )
            {
                MessageBox.Show("Error Found: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            textBox12.Clear();
            textBox11.Clear();
            textBox6.Clear();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                con.Open();
                // Fixed query: Use SUPPLIERS table and remove product condition if not provided
                // Use parameterized query to prevent SQL injection
                string query = "SELECT * FROM SUPPLIERS WHERE 1=1";
                List<string> conditions = new List<string>();
                List<SqlParameter> parameters = new List<SqlParameter>();

                if (!string.IsNullOrWhiteSpace(textBox12.Text))
                {
                    if (int.TryParse(textBox12.Text, out int supID))
                    {
                        conditions.Add("supID = @supID");
                        parameters.Add(new SqlParameter("@supID", supID));
                    }
                }
                if (!string.IsNullOrWhiteSpace(textBox11.Text))
                {
                    conditions.Add("company LIKE @company");
                    parameters.Add(new SqlParameter("@company", "%" + textBox11.Text + "%"));
                }
                if (!string.IsNullOrWhiteSpace(textBox6.Text))
                {
                    conditions.Add("product LIKE @product");
                    parameters.Add(new SqlParameter("@product", "%" + textBox6.Text + "%"));
                }

                if (conditions.Count > 0)
                {
                    query += " AND " + string.Join(" AND ", conditions);
                }

                cmd = new SqlCommand(query, con);
                cmd.Parameters.AddRange(parameters.ToArray());
                da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dataGridView1.DataSource = dt;
                con.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Found: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                if (con.State == ConnectionState.Open)
                    con.Close();
            }
        }



        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label25_Click(object sender, EventArgs e)
        {

        }
        private void  getGrid1()
        {
            try
            {
                if (con == null || con.State == ConnectionState.Closed)
                {
                    con = new SqlConnection("Data Source=LAPTOP-2956U5GC\\SQLEXPRESS;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
                    con.Open();
                }
                SqlDataAdapter daAll = new SqlDataAdapter("SELECT * FROM SUPPLIERS ORDER BY supID DESC", con);
                DataTable dataTable = new DataTable();
                daAll.Fill(dataTable);
                dataGridView2.DataSource = dataTable;
                con.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading suppliers: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                if (con != null && con.State == ConnectionState.Open)
                    con.Close();
            }
        }
        private string GetUserType(int positionID)
        {
            switch (positionID)
            {
                case 0: return "Regular";
                case 1: return "Whole Sale";
                default: return "Unknown";
            }
        }
    }
}
