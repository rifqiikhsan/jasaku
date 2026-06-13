import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  UseGuards,
  Put,
} from '@nestjs/common';

import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guard/jwt-auth.guard';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';

const commonErrorResponses = [
  ApiResponse({
    status: 400,
    description: 'Bad Request',
    schema: { example: { message: 'Bad request', status: 400 } },
  }),
  ApiResponse({
    status: 404,
    description: 'Not Found',
    schema: { example: { message: 'Resource not found', status: 404 } },
  }),
  ApiResponse({
    status: 499,
    description: 'Client Closed Request',
    schema: { example: { message: 'Client closed request', status: 499 } },
  }),
  ApiResponse({
    status: 504,
    description: 'Gateway Timeout',
    schema: { example: { message: 'Gateway timeout', status: 504 } },
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

@UseGuards(JwtAuthGuard)
@Controller('users')
@ApiTags('Users')
@ApiBearerAuth()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: 'Create user' })
  @ApiBody({ type: CreateUserDto })
  @ApiResponse({
    status: 201,
    description: 'User created successfully',
    schema: { example: { data: 'string', status: 201 } },
  })
  @ApiCommonErrors()
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all users' })
  @ApiResponse({
    status: 200,
    description: 'List of users',
    schema: {
      example: {
        status: 200,
        data: [
          {
            id: 0,
            fullName: 'string',
            email: 'string',
            role: 'string',
            createdAt: 'string',
            updatedAt: 'string',
          },
        ],
      },
    },
  })
  @ApiCommonErrors()
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by id' })
  @ApiResponse({
    status: 200,
    description: 'User detail',
    schema: {
      example: {
        status: 200,
        data: {
          id: 0,
          fullName: 'string',
          email: 'string',
          role: 'string',
          createdAt: 'string',
          updatedAt: 'string',
        },
      },
    },
  })
  @ApiCommonErrors()
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update user' })
  @ApiBody({ type: UpdateUserDto })
  @ApiResponse({
    status: 200,
    description: 'User updated',
    schema: { example: { data: '123', status: 200 } },
  })
  @ApiCommonErrors()
  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete user' })
  @ApiResponse({
    status: 200,
    description: 'User deleted',
    schema: { example: { message: 'User deleted successfully', status: 200 } },
  })
  @ApiCommonErrors()
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
