using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using System.Data;
using APIdb.Models;

namespace APIdb.Controllers
{

    public class EmpleadosController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public EmpleadosController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("GetEmpleados")]
        public IActionResult GetEmpleados([FromBody] Empleados empleados)
        {
            try
            {
                // Conexión a la base de datos
                string sqlDatasource = _configuration.GetConnectionString("connection");
                DataTable empleadoTable = new DataTable();  // Crear una tabla para los empleados

                using (SqlConnection connection = new SqlConnection(sqlDatasource))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("SP_ListarEmpleados", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@inIdUser", 5);
                        command.Parameters.AddWithValue("@inUsername", "luis23");
                        command.Parameters.AddWithValue("@inPostIP", "127.0.0.1");

                        SqlParameter retornoParameter = new SqlParameter("@outRetorno", SqlDbType.Bit);
                        retornoParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(retornoParameter);

                        SqlParameter messageParameter = new SqlParameter("@outMessage", SqlDbType.VarChar, 100);
                        messageParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(messageParameter);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            adapter.Fill(empleadoTable);
                        }

                        bool retorno = (bool)retornoParameter.Value;
                        string message = messageParameter.Value.ToString();

                        var response = new
                        {
                            StatusCode = retorno,
                            StatusMessage = message,
                            Empleados = empleadoTable
                        };

                        return Ok(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al obtener empleados: " + ex.Message);
            }
        }
    }
}