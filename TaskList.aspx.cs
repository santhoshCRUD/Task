using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Task.Task;
using System.Configuration;
using System.Web.Services;



namespace Task
{
    public partial class TaskList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        static string conS = ConfigurationManager.AppSettings["dbConStr"].ToString();


        public class LstTask
        {
            public List<TaskInitiationGS> ObjProjectInit = new List<TaskInitiationGS>();
        }
        public static LstTask GetTaskList()
        {
            try
            {
                LstTask lstProjectInitList = new LstTask();
                using (SqlConnection con = new SqlConnection(conS))
                {
                    using (SqlCommand cmd = new SqlCommand("ViewTaskData", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dtObj = new DataTable();
                        da.Fill(dtObj);
                        if (dtObj != null && dtObj.Rows.Count > 0)
                        {
                            foreach (DataRow drPC in dtObj.Rows)
                            {

                                TaskInitiationGS objHP = new TaskInitiationGS();

                                objHP.Id = Convert.ToInt32(drPC["Id"].ToString());
                                objHP.TaskName = drPC["ProjectName"].ToString();
                                objHP.Description = drPC["FacilityName"].ToString();
                                objHP.Deadline = drPC["ProjectLocation"].ToString();
                                objHP.CreatedOn = drPC["CreatedOn"].ToString();

                                lstProjectInitList.ObjProjectInit.Add(objHP);
                            }
                        }
                    }
                }

                return lstProjectInitList;

            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        [WebMethod]
        public static int DeleteTask(int Id)
        {
            try
            {

                int affectedRows = 0;
                using (SqlConnection con = new SqlConnection(conS))
                {
                    using (SqlCommand cmd = new SqlCommand("DeleteTask", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;

                        con.Open();
                        affectedRows = cmd.ExecuteNonQuery();
                    }
                }
                return affectedRows;
            }
            catch (Exception ex)
            {

                throw (ex);
            }
        }

    }


}