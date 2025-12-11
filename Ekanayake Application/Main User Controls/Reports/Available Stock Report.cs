using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ekanayake_Printers_RMS.Main_User_Controls.Manager_User_Control
{
    public partial class Available_Stock_Report : UserControl
    {
        public Available_Stock_Report()
        {
            try
            {
                InitializeComponent();
            }
            catch (System.TypeInitializationException ex)
            {
                MessageBox.Show(
                    "Crystal Reports initialization failed. Missing log4net dependency.\n\n" +
                    "Please install log4net package:\n" +
                    "1. Right-click project → Manage NuGet Packages\n" +
                    "2. Search for 'log4net'\n" +
                    "3. Install version 1.2.10\n" +
                    "4. Rebuild the solution\n\n" +
                    "Error: " + ex.Message,
                    "Crystal Reports Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Error initializing Crystal Reports viewer:\n\n" + ex.Message + "\n\n" +
                    "Inner Exception: " + (ex.InnerException?.Message ?? "None"),
                    "Initialization Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }
    }
}
