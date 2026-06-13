import { Body, Controller, Post } from '@nestjs/common';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';

import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

const commonErrorResponses = [
  ApiResponse({
    status: 400,
    description: 'Bad Request',
    schema: { example: { status: 400, message: 'Bad request' } },
  }),
  ApiResponse({
    status: 404,
    description: 'Not Found',
    schema: { example: { status: 404, message: 'Resource not found' } },
  }),
  ApiResponse({
    status: 499,
    description: 'Client Closed Request',
    schema: { example: { status: 499, message: 'Client closed request' } },
  }),
  ApiResponse({
    status: 504,
    description: 'Gateway Timeout',
    schema: { example: { status: 504, message: 'Gateway timeout' } },
  }),
];

function ApiCommonErrors(): MethodDecorator {
  return (target, key, descriptor) => {
    commonErrorResponses.forEach((decorator) =>
      decorator(target, key, descriptor),
    );
    return descriptor;
  };
}

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register user' })
  @ApiBody({ type: RegisterDto })
  @ApiResponse({
    status: 201,
    description: 'Register success',
    schema: {
      example: {
        status: 201,
        data: 'string',
      },
    },
  })
  @ApiCommonErrors()
  register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @ApiOperation({ summary: 'Login user' })
  @ApiBody({ type: LoginDto })
  @ApiResponse({
    status: 200,
    description: 'Login success',
    schema: {
      example: {
        status: 200,
        data: {
          accessToken: 'string',
          user: {
            id: 1,
            fullName: 'string',
            email: 'string',
            role: 'string',
            createdAt: 'string',
            updatedAt: 'string',
          },
        },
      },
    },
  })
  @ApiCommonErrors()
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }
}
