using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;


namespace EEMigrationTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                var connectionString = ConfigurationManager.ConnectionStrings["Migration_ConnectionString"].ToString();
                SqlConnection sqlConnection = new SqlConnection(connectionString);
                SqlCommand command = new SqlCommand("sp_GetSIMList_Migration", sqlConnection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@enterPriseID", SqlDbType.Int).Value = txt1.Text;
                command.Parameters.Add("@internalStatusID", SqlDbType.Int).Value = txt2.Text;
                sqlConnection.Open();
                SqlDataAdapter adapter;
                DataSet ds = new DataSet();
                adapter = new SqlDataAdapter(command);
                adapter.Fill(ds);

                dgv1.AutoGenerateColumns = true;
                dgv1.DataSource = ds;
              //  sqlConnection.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
                
            }
        }
    }
}
