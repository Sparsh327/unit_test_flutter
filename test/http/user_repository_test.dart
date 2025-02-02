import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unit_test/http/user_model.dart';
import 'package:flutter_unit_test/http/user_repository.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    userRepository = UserRepository(mockHttpClient);
  });
  group(
    "User Repository",
    () {
      group(
        "Get User",
        () {
          test(
            "given user repository when get user function is called and status code is 200 then return user",
            () async {
              when(
                () => mockHttpClient.get(
                  Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
                ),
              ).thenAnswer(
                (_) async => Response(
                  '''
                    {
                      "id": 1,
                      "name": "Leanne Graham",
                      "username": "Bret",
                      "email": "Sincere@april.biz",
                      "address": {
                        "street": "Kulas Light",
                        "suite": "Apt. 556",
                        "city": "Gwenborough",
                        "zipcode": "92998-3874",
                        "geo": {
                          "lat": "-37.3159",
                          "lng": "81.1496"
                        }
                      },
                      "phone": "1-770-736-8031 x56442",
                      "website": "hildegard.org",
                      "company": {
                        "name": "Romaguera-Crona",
                        "catchPhrase": "Multi-layered client-server neural-net",
                        "bs": "harness real-time e-markets"
                      }
                    }
                   ''',
                  200,
                ),
              );
              final user = await userRepository.getUser();
              expect(
                user,
                isA<User>(),
              );
            },
          );

          test(
            "given user repository when get user function is called and status code is not 200 then throw exception",
            () async {
              when(
                () => mockHttpClient.get(
                  Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
                ),
              ).thenAnswer(
                (_) async => Response('{}', 500),
              );
              final user = userRepository.getUser();
              expect(
                user,
                throwsException,
              );
            },
          );
        },
      );
    },
  );
}
