
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;
using APIdb.Models;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FiltroCantidadController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public FiltroCantidadController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("GetByAmount")]
        public JsonResult FiltroCantidad([FromBody] FiltroCantidad request)
        {
            // Tabla artículos de respuesta
            DataTable articleTable = new DataTable();

            // Se obtiene la IP 
            var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
            var ip = clientIpAddress.ToString();

            using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("MostrarArticulosPorCantidad", connection);
                command.CommandType = CommandType.StoredProcedure;

                // Usar los valores proporcionados en la solicitud en lugar de valores fijos
                command.Parameters.AddWithValue("@cantidadN", request.cantidadN);
                command.Parameters.AddWithValue("@Username", "pablo");
                command.Parameters.AddWithValue("@PostIP", ip);

                // Configura los parámetros de salida
                SqlParameter autenticadoParam = new SqlParameter("@Resultado", SqlDbType.Bit);
                autenticadoParam.Direction = ParameterDirection.Output;
                command.Parameters.Add(autenticadoParam);

                SqlParameter messageParam = new SqlParameter("@Message", SqlDbType.VarChar, 100);
                messageParam.Direction = ParameterDirection.Output;
                command.Parameters.Add(messageParam);

                // Ejecuta el SP
                command.ExecuteNonQuery();

                // Crear un adaptador de datos para llenar la tabla
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(articleTable);
                }

                // Recupera los valores de los parámetros de salida
                bool autenticado = (bool)autenticadoParam.Value;
                string message = messageParam.Value.ToString();

                // Crea una instancia de tu modelo de respuesta
                var response = new
                {
                    statusCode = autenticado,
                    statusMessage = message,
                    Articles = articleTable // Agrega la tabla de artículos a la respuesta
                };

                return new JsonResult(response);
            }
        }
    }
}
