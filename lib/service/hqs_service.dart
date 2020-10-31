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
  }


  // methods to call on server
  Future<Token> authenticate(String email, String password) async {
      token.clearToken();
      
      User authUser = User()..email=email..password=password;

      // validate
      if(email.isEmpty || password.isEmpty){
        return token;
      }

      try{
        token = await client.auth(authUser).then((val) {print(val); return val;});
      }
      catch(e){
        print('Caught error: $e');
      }
      return token;
    }
}