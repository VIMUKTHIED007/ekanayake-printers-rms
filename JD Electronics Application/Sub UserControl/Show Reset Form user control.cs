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
    public partial class Show_Reset_Form_user_control : UserControl
    {
        public Show_Reset_Form_user_control()
        {
            InitializeComponent();
        }

        private void btnbtnUpdate_Click(object sender, EventArgs e)
        {
            string connectionString = "Data Source=THONKPAD;Initial Catalog=EKANAYAKE_PRINTERS_001;Integrated Security=True";
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    //string query2 = ""

                }
                catch (Exception Ex)
                {
                    MessageBox.Show("Reset Passward Error..!" + Ex.Message);

                }
            }
        }
    }
}
