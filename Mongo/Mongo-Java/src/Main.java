import com.mongodb.Block;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import org.bson.conversions.Bson;

import static com.mongodb.client.model.Filters.*;
import java.util.ArrayList;
import java.util.List;

import static java.lang.reflect.Array.set;
import static java.util.Arrays.asList;


public class Main {
    public static void main(String[] args) {
        // se crea la conexion
        MongoClient client = new MongoClient("localhost",27017);
        MongoDatabase database = client.getDatabase("TpMongo1-Incutti,Sampieri");
        MongoCollection<Document> collection = database.getCollection("Hotel");

        Document hotel4 = new Document();
        hotel4.append ("nombre", "granContinentalJuan")
                .append("direccion", "main road 3")
                .append("telefono", 1189542202)
                .append("sectores", asList(new Document("nroRecepcion", 12), new Document("nroSpa", 342), new Document("nroPiscina", 512)))
                .append("servicios", asList(new Document("convenciones", true), new Document("petFriendly", false), new Document("cajaFuerte", true), new Document("wi-fi", false)))
                .append("comodidades", asList(new Document("restaurante", true), new Document("spa", false), new Document("piscina", true)))
                .append("promociones", asList(new Document("nombre", "discapacitados").append("%descuento", 25), new Document("nombre", "menores").append("%descuento", 10)))
                .append("puntosInteres", asList(new Document("parque", new Document("nombre", "Alem").append("direccion","bolivia 5717").append("telefono",123131).append("sitioWeb","www.alem.com")),
                                                new Document("teatro", new Document("nombre", "luna park").append("direccion","av corrientes 5600").append("telefono",131312312).append("sitioWeb","www.lunapark.com")),
                                                new Document("museo", new Document("nombre", "aeronautico").append("direccion","av cordoba 3460").append("telefono",7325568).append("sitioWeb","www.museoAeronautico.com"))))
                .append("numerosUtiles", asList(new Document("policia",911),new Document("ambulancia",106), new Document("abuso",144)));

        Document hotel5 = new Document();
        hotel5.append ("nombre", "Lucas Panijuan")
                .append("direccion", "mosconi 3469")
                .append("telefono", 1190946935)
                .append("sectores", asList(new Document("nroRecepcion", 20), new Document("nroSpa", 245), new Document("nroPiscina", 895)))
                .append("servicios", asList(new Document("convenciones", false), new Document("petFriendly", false), new Document("cajaFuerte", true), new Document("wi-fi", true)))
                .append("comodidades", asList(new Document("restaurante", false), new Document("spa", true), new Document("piscina", true)))
                .append("promociones", asList(new Document("nombre", "Colorados").append("%descuento", 32), new Document("nombre", "mujeres").append("%descuento", 100)))
                .append("puntosInteres", asList(new Document("parque", new Document("nombre", "larrlde").append("direccion","aizpurua 3363").append("telefono",123131).append("sitioWeb","www.larralde.com")),
                        new Document("teatro", new Document("nombre", "ratti").append("direccion","nahuel huapi 5600").append("telefono",131312312).append("sitioWeb","www.ratti.com")),
                        new Document("museo", new Document("nombre", "tango").append("direccion","tamborini 6167").append("telefono",2532895).append("sitioWeb","www.tango.com"))))
                .append("numerosUtiles", asList(new Document("policia",911),new Document("ambulancia",106), new Document("abuso",144)));

        List<Document> documentos = new ArrayList<>();
        documentos.add(hotel4);
        documentos.add(hotel5);
       // collection.insertMany(documentos);


        /* Ejercicio 10 */
        List<Document> promoJubilados = collection.find(eq("promociones.nombre", "jubilados")).into(new ArrayList<>());
        System.out.println("Hotel list with an ArrayList:");
        for (Document promoActual : promoJubilados) {
            System.out.println(promoActual.toJson());
        }

        /* Ejercicio 11 */
        UpdateResult result = collection.updateMany((eq("numerosUtiles.policia", 911)), new Document("$set",new Document("numerosUtiles.$.policia", "0800-222-police")));
        System.out.println(result);

        /* Ejercicio 12 */

        List<Document> museos = collection.find(eq("puntosInteres.museo.nombre", "Malba")).into(new ArrayList<>());
        System.out.println("Hotel list with an ArrayList:");
        for (Document museoActual : museos) {
            System.out.println(museoActual.toJson());
        }

        /* Ejercicio 17 */
        List<Document> ejemploOr = collection.find(or(eq("comodidades.spa",true),eq("comodidades.piscina",true))).into(new ArrayList<>());
        System.out.println("Hotel list with an ArrayList:");
        for (Document orActual : ejemploOr) {
            System.out.println(orActual.toJson());
        }

        /* Ejercicio 21 */
        DeleteResult deleteResult=collection.deleteMany(eq("promociones",null));
        System.out.println(deleteResult);




    }
}
