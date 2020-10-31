import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class HqsService {  
  UserServiceClient client;
  Token token = Token();

  HqsService(String addr, int port){
    client = UserServiceClient(
      ClientChannel(addr, port:port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        )
      )
    );

    //authenticate("root@softcorp.io", "Ud0FycGKEäDPLnW0å2e0Qz");
  }


  // methods to call on server
  Future<Token> authenticate(String email, String password) async {
      print("recieved authentication attempt with email:"+email+" and password: "+password);
      Token token = Token();
      
      print("client");
      print(client);

      User authUser = User()..email=email..password=password;

      // validate
      if(email.isEmpty || password.isEmpty){
        return token;
      }

      try{
        print("Trying to authenticate...");
        token = await client.auth(authUser)/* .then((val) {print(val); return val;}) */;
        print("Authentication success");
      } catch(e){
        print('Caught error: $e');
      }
      return token;
    }
}