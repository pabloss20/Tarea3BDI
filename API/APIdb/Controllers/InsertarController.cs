﻿using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InsertarController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public InsertarController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // POST el cual se usa para validar un usuario
        [HttpPost]
        [Route("Insert")]
        public IActionResult InsertarArticulo([FromBody] Insertar insertar)
        {
            try
            {
                var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
                var ip = clientIpAddress.ToString();
                

                // Conexión en appsettings.json
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    // Inicia la conexión
                    connection.Open();
                    // Se llama al SP (nombre de SP, conexión)
                    SqlCommand command = new SqlCommand("InsertarArticulo", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    // Configura los parámetros de entrada (BD, Modelo)
                    command.Parameters.AddWithValue("@Username", "pablo");
                    command.Parameters.AddWithValue("@PostIP", ip);
                    command.Parameters.AddWithValue("@inIdClaseArticulo", insertar.inIdClaseArticulo);
                    command.Parameters.AddWithValue("@inCodigo", insertar.inCodigo);
                    command.Parameters.AddWithValue("@inNombre", insertar.inNombre);
                    command.Parameters.AddWithValue("@inPrecio", insertar.inPrecio);

                    // Configura los parámetros de salida
                    SqlParameter autenticadoParam = new SqlParameter("@outRegistrado", SqlDbType.Bit);
                    autenticadoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(autenticadoParam);

                    SqlParameter messageParam = new SqlParameter("@outMessage", SqlDbType.VarChar, 100);
                    messageParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(messageParam);

                    // Ejecuta el SP
                    command.ExecuteNonQuery();

                    // Recupera los valores de los parámetros de salida
                    bool autenticado = (bool)autenticadoParam.Value;
                    string message = messageParam.Value.ToString();

                    // Crea una instancia de tu modelo de respuesta
                    var response = new Response
                    {
                        statusCode = autenticado,
                        statusMessage = message
                        // Puedes agregar más propiedades según sea necesario
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
