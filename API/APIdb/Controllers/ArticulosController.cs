using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data.SqlClient;
using System.Data;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ArticulosController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public ArticulosController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        [Route("GetArticulos")]
        public JsonResult GetArticulos()
        {
            // Conexión a la base de datos
            string sqlDatasource = _configuration.GetConnectionString("connection");
            DataTable articleTable = new DataTable();  // Crear una tabla para los artículos

            using (SqlConnection connection = new SqlConnection(sqlDatasource))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("ConsultarArticulos", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Parámetro de entrada (si es necesario)
                    command.Parameters.AddWithValue("@Username", "pablo");

                    // Parámetros de salida
                    SqlParameter retornoParameter = new SqlParameter("@consulta_exitosa", SqlDbType.Bit);
                    retornoParameter.Direction = ParameterDirection.Output;
                    command.Parameters.Add(retornoParameter);

                    SqlParameter messageParameter = new SqlParameter("@Message", SqlDbType.VarChar, 100);
                    messageParameter.Direction = ParameterDirection.Output;
                    command.Parameters.Add(messageParameter);

                    // Crear un adaptador de datos para llenar la tabla
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(articleTable);
                    }

                    // Obtener los valores de los parámetros de salida
                    bool retorno = (bool)retornoParameter.Value;
                    string message = messageParameter.Value.ToString();

                    // Crear el objeto de respuesta que incluye los datos
                    var response = new
                    {
                        StatusCode = retorno,
                        StatusMessage = message,
                        Articles = articleTable // Agrega la tabla de artículos a la respuesta
                    };

                    return new JsonResult(response);
                }
            }
        }
    }
}
