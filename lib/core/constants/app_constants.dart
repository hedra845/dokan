// API
const String kApiBaseUrl = 'https://phoenixsystems.online/delivery-api/api/v1';
const String kLoginEndpoint = '$kApiBaseUrl/auth/login';
const String kRegisterClientEndpoint = '$kApiBaseUrl/auth/register/client';
const String kRegisterRestaurantEndpoint = '$kApiBaseUrl/auth/register/restaurant';
const String kRegisterDriverEndpoint = '$kApiBaseUrl/auth/register/driver';
const String kForgotPasswordEndpoint = '$kApiBaseUrl/auth/forgot-password';
const String kCustomerProfileEndpoint = '$kApiBaseUrl/clients/me/profile';
const String kAddAddressEndpoint = '$kApiBaseUrl/clients/me/addresses';
const String kCuisinesEndpoint = '$kApiBaseUrl/cuisines';
const String kRestaurantsEndpoint = '$kApiBaseUrl/restaurants';
const String kDriverProfileEndpoint = '$kApiBaseUrl/drivers/me/profile';
const String kProfileEndpoint = '$kApiBaseUrl/users/me';

const String kAppName = 'Phoenix';
const String kAppTagline = 'اطلب أكلك بسهولة';
const double kDefaultDeliveryFee = 20.0;
const Duration kAnimDuration = Duration(milliseconds: 300);

// Route names
const String kRouteSplash = '/';
const String kRouteWelcome = '/welcome';
const String kRouteLogin = '/login';
const String kRouteCustomerHome = '/customer/home';
const String kRouteRestaurantDash = '/restaurant/dashboard';
const String kRouteDriverHome = '/driver/home';

// Mock login credentials
const String kMockCustomerEmail = 'customer@test.com';
const String kMockCustomerPhone = '01011111111';
const String kMockRestaurantEmail = 'restaurant@test.com';
const String kMockRestaurantPhone = '01022222222';
const String kMockDriverEmail = 'driver@test.com';
const String kMockDriverPhone = '01000000000';
const String kMockPassword = '123456';
