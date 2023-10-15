using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActualizarController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public ActualizarController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("UpdateArticle")]
        public JsonResult ActualizarArticulo([FromBody] Actualizar actualizar)
        {
            var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
            var ip = clientIpAddress.ToString();

            // Variables para capturar el resultado de la actualización
            bool actualizacionExitosa = false;
            string mensajeActualizacion = string.Empty;

            try
            {
                // Crear la conexión a la base de datos
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection")))
                {
                    connection.Open();

                    // Crear el comando para ejecutar el procedimiento almacenado
                    using (SqlCommand command = new SqlCommand("ActualizarArticulo", connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;

                        // Configurar los parámetros del procedimiento almacenado
                        command.Parameters.AddWithValue("@Username", actualizar.Username);
                        command.Parameters.AddWithValue("@PostIP", ip);
                        command.Parameters.AddWithValue("@inIdClaseArticulo", actualizar.IdClaseArticulo);
                        command.Parameters.AddWithValue("@anteriorIdClase", actualizar.AnteriorIdClase);
                        command.Parameters.AddWithValue("@idArticulo", actualizar.IdArticulo);
                        command.Parameters.AddWithValue("@inCodigo", actualizar.CodigoNuevo);
                        command.Parameters.AddWithValue("@anteriorCodigo", actualizar.CodigoAnterior);
                        command.Parameters.AddWithValue("@inNombre", actualizar.NombreNuevo);
                        command.Parameters.AddWithValue("@anteriorNombre", actualizar.NombreAnterior);
                        command.Parameters.AddWithValue("@inPrecio", actualizar.Precio);

                        // Parámetros de salida
                        SqlParameter outRegistrado = new SqlParameter("@outRegistrado", System.Data.SqlDbType.Bit);
                        outRegistrado.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(outRegistrado);

                        SqlParameter outMessage = new SqlParameter("@outMessage", System.Data.SqlDbType.VarChar, 100);
                        outMessage.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(outMessage);

                        // Ejecutar el procedimiento almacenado
                        command.ExecuteNonQuery();

                        // Obtener los valores de los parámetros de salida
                        actualizacionExitosa = (bool)outRegistrado.Value;
                        mensajeActualizacion = outMessage.Value.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                // Manejar cualquier excepción que pueda ocurrir durante la actualización
                actualizacionExitosa = false;
                mensajeActualizacion = "Error durante la actualización: " + ex.Message;
            }

            // Crear la respuesta JSON
            var response = new
            {
                StatusCode = actualizacionExitosa ? 1 : 0,
                StatusMessage = mensajeActualizacion
            };

            return new JsonResult(response);
        }
    }
}
