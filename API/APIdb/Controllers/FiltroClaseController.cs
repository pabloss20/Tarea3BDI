using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Data;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FiltroClaseController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public FiltroClaseController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // POST el cual se usa para validar un usuario
        [HttpPost]
        [Route("GetByClass")]
        public IActionResult FiltroClase([FromBody] FiltroClase filtroClase)
        {
            try
            {

                // Tabla artículos de respuesta
                DataTable articleTable = new DataTable();

                var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
                var ip = clientIpAddress.ToString();

                // Conexión en appsettings.json
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    // Inicia la conexión
                    connection.Open();
                    // Se llama al SP (nombre de SP, conexión)
                    SqlCommand command = new SqlCommand("MostrarArticulosPorClase", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    // Configura los parámetros de entrada (BD, Modelo)
                    command.Parameters.AddWithValue("@Username", "pablo");
                    command.Parameters.AddWithValue("@idClaseArticulo", filtroClase.IdClase);
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

                    return Ok(response);
                }
            }
            catch (Exception ex)
            {
                // Maneja errores aquí
                return StatusCode(500, "Error al autenticar: " + ex.Message);
            }
        }
    }
}
