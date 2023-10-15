using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SignupController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public SignupController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // POST el cual se usa para registrar un nuevo usuario
        [HttpPost]
        [Route("Signup")]
        public IActionResult Signup([FromBody] Signup signup)
        {
            try
            {
                // Conexión en appsettings.json
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    // Inicia la conexión
                    connection.Open();
                    // Se llama al SP (nombre de SP, conexión)
                    SqlCommand command = new SqlCommand("RegistrarUsuario", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada (BD, Modelo)
                    command.Parameters.AddWithValue("@UserName", signup.UserName);
                    command.Parameters.AddWithValue("@Password", signup.Password);

                    // Parámetros de salida
                    SqlParameter registradoParam = new SqlParameter("@Registrado", SqlDbType.Bit);
                    registradoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(registradoParam);

                    SqlParameter messageParam = new SqlParameter("@Message", SqlDbType.VarChar, 100);
                    messageParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(messageParam);

                    // Ejecuta el procedimeinto almacenado
                    command.ExecuteNonQuery();

                    // Obtiene los valores de los parámetros de salida
                    bool registrado = (bool)registradoParam.Value;
                    string message = messageParam.Value.ToString();

                    // Instancia de tu modelo de respuesta
                    var response = new Response
                    {
                        statusCode = registrado,
                        statusMessage = message
                    };

                    return Ok(response);
                }
            }
            catch (Exception ex)
            {
                // Manejo de errores
                return StatusCode(500, "Error al registrar el usuario: " + ex.Message);
            }
        }
    }
}
