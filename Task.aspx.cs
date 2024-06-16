using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Task.Task;

namespace Task
{

    public partial class Task : System.Web.UI.Page
    {
        static string conS = ConfigurationManager.AppSettings["dbConStr"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static int SaveOrUpdateTask(TaskInitiationGS objTask)
        {
            try
            {

                int affectedRows = 0;
                using (SqlConnection con = new SqlConnection(conS))
                {
                    using (SqlCommand cmd = new SqlCommand("SaveOrUpdateTask", con))
                    {

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Id", SqlDbType.Int).Value = objTask.Id;
                        cmd.Parameters.Add("@TaskName", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(objTask.TaskName) ? null : objTask.TaskName;
                        cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = string.IsNullOrEmpty(objTask.Description) ? null : objTask.Description;
                        cmd.Parameters.Add("@Deadline", SqlDbType.DateTime).Value = string.IsNullOrEmpty(objTask.Deadline) ? (object)DBNull.Value : objTask.Deadline;

                        con.Open();
                        affectedRows = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }


                return affectedRows;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }


        [WebMethod]
        public static TaskInitiationGS EditProjectInitiation(int Id)
        {
            try
            {
                TaskInitiationGS objHP = new TaskInitiationGS();
                using (SqlConnection con = new SqlConnection(conS))
                {
                    using (SqlCommand cmd = new SqlCommand("GetTaskData", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
                        con.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dtObj = new DataTable();
                        da.Fill(dtObj);
                        if (dtObj != null && dtObj.Rows.Count > 0)
                        {
                            foreach (DataRow drPC in dtObj.Rows)
                            {

                                objHP.Id = Convert.ToInt32(drPC["Id"].ToString());
                                objHP.TaskName = drPC["TaskName"].ToString();
                                objHP.Description = drPC["Description"].ToString();
                                objHP.Deadline = drPC["Deadline"].ToString();


                            }
                        }
                    }
                }

                return objHP;
            }
            catch (Exception ex)
            {
                throw (ex);
            }


        }
    }

}
