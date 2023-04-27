// const response = require('cfn-response');
// const aws = require('aws-sdk');
// const identity = new aws.CognitoIdentityServiceProvider();
// exports.handler = (event, context, callback) => {
//   if (event.RequestType == 'Delete') {
//     response.send(event, context, response.SUCCESS, {});
//   }
//   if (event.RequestType == 'Update' || event.RequestType == 'Create') {
//     const params = {
//       ClientId: event.ResourceProperties.clientId,
//       UserPoolId: event.ResourceProperties.userpoolId,
//     };
//     identity
//       .describeUserPoolClient(params)
//       .promise()
//       .then(res => {
//         response.send(event, context, response.SUCCESS, { appSecret: res.UserPoolClient.ClientSecret });
//       })
//       .catch(err => {
//         response.send(event, context, response.FAILED, { err });
//       });
//   }
// };



// "use strict";
// const CUSTOM_CHALLENGE = 'CUSTOM_CHALLENGE';
// exports.handler = async (event, context) => {
//     if (event.request.session && event.request.session.find((attempt) => attempt.challengeName !== CUSTOM_CHALLENGE)) {
//         // We only accept custom challenges; fail auth
//         event.response.issueTokens = false;
//         event.response.failAuthentication = true;
//     }
//     else if (event.request.session &&
//         event.request.session.length >= 3 &&
//         event.request.session.slice(-1)[0].challengeResult === false) {
//         // The user provided a wrong answer 3 times; fail auth
//         event.response.issueTokens = false;
//         event.response.failAuthentication = true;
//     }
//     else if (event.request.session &&
//         event.request.session.length &&
//         event.request.session.slice(-1)[0].challengeName === CUSTOM_CHALLENGE && // Doubly stitched, holds better
//         event.request.session.slice(-1)[0].challengeResult === true) {
//         // The user provided the right answer; succeed auth
//         event.response.issueTokens = true;
//         event.response.failAuthentication = false;
//     }
//     else {
//         // The user did not provide a correct answer yet; present challenge
//         event.response.issueTokens = false;
//         event.response.failAuthentication = false;
//         event.response.challengeName = CUSTOM_CHALLENGE;
//     }
//     console.log('event', event);
//     context.done(null, event);
//     return event;
// };
// //# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiaW5kZXguanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi8uLi8uLi8uLi9zcmMvcGFja2FnZWRfanMvY29nbml0b190cmlnZ2Vyc19hcnRpZmFjdHMvYW1wbGlmeS1sb2dpbi1kZWZpbmUtYXV0aC1jaGFsbGVuZ2UvaW5kZXguanMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLE1BQU0sZ0JBQWdCLEdBQUcsa0JBQWtCLENBQUM7QUFDNUMsT0FBTyxDQUFDLE9BQU8sR0FBRyxLQUFLLEVBQUUsS0FBSyxFQUFFLE9BQU8sRUFBRSxFQUFFO0lBQ3pDLElBQUksS0FBSyxDQUFDLE9BQU8sQ0FBQyxPQUFPLElBQUksS0FBSyxDQUFDLE9BQU8sQ0FBQyxPQUFPLENBQUMsSUFBSSxDQUFDLENBQUMsT0FBTyxFQUFFLEVBQUUsQ0FBQyxPQUFPLENBQUMsYUFBYSxLQUFLLGdCQUFnQixDQUFDLEVBQUU7UUFDaEgsOENBQThDO1FBQzlDLEtBQUssQ0FBQyxRQUFRLENBQUMsV0FBVyxHQUFHLEtBQUssQ0FBQztRQUNuQyxLQUFLLENBQUMsUUFBUSxDQUFDLGtCQUFrQixHQUFHLElBQUksQ0FBQztLQUMxQztTQUFNLElBQ0wsS0FBSyxDQUFDLE9BQU8sQ0FBQyxPQUFPO1FBQ3JCLEtBQUssQ0FBQyxPQUFPLENBQUMsT0FBTyxDQUFDLE1BQU0sSUFBSSxDQUFDO1FBQ2pDLEtBQUssQ0FBQyxPQUFPLENBQUMsT0FBTyxDQUFDLEtBQUssQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLGVBQWUsS0FBSyxLQUFLLEVBQzVEO1FBQ0Esc0RBQXNEO1FBQ3RELEtBQUssQ0FBQyxRQUFRLENBQUMsV0FBVyxHQUFHLEtBQUssQ0FBQztRQUNuQyxLQUFLLENBQUMsUUFBUSxDQUFDLGtCQUFrQixHQUFHLElBQUksQ0FBQztLQUMxQztTQUFNLElBQ0wsS0FBSyxDQUFDLE9BQU8sQ0FBQyxPQUFPO1FBQ3JCLEtBQUssQ0FBQyxPQUFPLENBQUMsT0FBTyxDQUFDLE1BQU07UUFDNUIsS0FBSyxDQUFDLE9BQU8sQ0FBQyxPQUFPLENBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsYUFBYSxLQUFLLGdCQUFnQixJQUFJLGdDQUFnQztRQUN6RyxLQUFLLENBQUMsT0FBTyxDQUFDLE9BQU8sQ0FBQyxLQUFLLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxlQUFlLEtBQUssSUFBSSxFQUMzRDtRQUNBLG1EQUFtRDtRQUNuRCxLQUFLLENBQUMsUUFBUSxDQUFDLFdBQVcsR0FBRyxJQUFJLENBQUM7UUFDbEMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxrQkFBa0IsR0FBRyxLQUFLLENBQUM7S0FDM0M7U0FBTTtRQUNMLG1FQUFtRTtRQUNuRSxLQUFLLENBQUMsUUFBUSxDQUFDLFdBQVcsR0FBRyxLQUFLLENBQUM7UUFDbkMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxrQkFBa0IsR0FBRyxLQUFLLENBQUM7UUFDMUMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxhQUFhLEdBQUcsZ0JBQWdCLENBQUM7S0FDakQ7SUFFRCxPQUFPLENBQUMsR0FBRyxDQUFDLE9BQU8sRUFBRSxLQUFLLENBQUMsQ0FBQztJQUM1QixPQUFPLENBQUMsSUFBSSxDQUFDLElBQUksRUFBRSxLQUFLLENBQUMsQ0FBQztJQUUxQixPQUFPLEtBQUssQ0FBQztBQUNmLENBQUMsQ0FBQyJ9

// // import 'package:http/http.dart' as http;
// // import 'package:amazon_cognito_identity_dart_2/cognito.dart';
// // import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

// // void main() async {
// //   final userPool = CognitoUserPool(
// //   'ap-southeast-1_xxxxxxxxx',
// //   'xxxxxxxxxxxxxxxxxxxxxxxxxx',
// // );
// //   final credentials = CognitoCredentials(
// //       'ap-southeast-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', userPool);
// //   await credentials.getAwsCredentials(session.getIdToken().getJwtToken());

// //   const endpoint =
// //       'https://xxxx.execute-api.ap-southeast-1.amazonaws.com/dev';
// //   final awsSigV4Client = AwsSigV4Client(
// //       credentials.accessKeyId, credentials.secretAccessKey, endpoint,
// //       sessionToken: credentials.sessionToken,
// //       region: 'ap-southeast-1');

// //   final signedRequest = SigV4Request(awsSigV4Client,
// //       method: 'POST',
// //       path: '/projects',
// //       headers: Map<String, String>.from(
// //           {'header-1': 'one', 'header-2': 'two'}),
// //       queryParams: Map<String, String>.from({'tracking': 'x123'}),
// //       body: Map<String, dynamic>.from({'color': 'blue'}));

// //   http.Response response;
// //   try {
// //     response = await http.post(
// //       signedRequest.url,
// //       headers: signedRequest.headers,
// //       body: signedRequest.body,
// //     );
// //   } catch (e) {
// //     print(e);
// //   }
// //   print(response.body);
// // }