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
import { ServicesService } from './services.service';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guard/jwt-auth.guard';

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
@Controller('services')
@ApiTags('Services')
@ApiBearerAuth()
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @Post()
  @ApiOperation({ summary: 'Create service' })
  @ApiBody({ type: CreateServiceDto, isArray: true })
  @ApiResponse({
    status: 201,
    description: 'Service created successfully',
    schema: { example: { data: ['string'], status: 201 } },
  })
  @ApiCommonErrors()
  async create(
    @Body() createServiceDto: CreateServiceDto | CreateServiceDto[],
  ) {
    if (Array.isArray(createServiceDto)) {
      const results = await Promise.all(
        createServiceDto.map((item) => this.servicesService.create(item)),
      );

      return {
        status: 201,
        data: results.map((item) => item.data),
      };
    }

    return this.servicesService.create(createServiceDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all services' })
  @ApiResponse({
    status: 200,
    description: 'List of services',
    schema: {
      example: {
        status: 200,
        data: [
          {
            id: 'string',
            serviceName: 'string',
            category: ['string'],
            summaryRating: 4.8,
            distance: 'string',
            totalReviews: 120,
            priceMinimum: 'string',
            emoji: 'string',
            emojiColor: 'red|blue|green|yellow|purple',
            isVerification: 'Y|N',
            createdAt: 'string',
            updatedAt: 'string',
          },
        ],
      },
    },
  })
  @ApiCommonErrors()
  findAll() {
    return this.servicesService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get service by id' })
  @ApiResponse({
    status: 200,
    description: 'Service detail',
    schema: {
      example: {
        status: 200,
        data: {
          id: 'string',
          serviceName: 'string',
          category: ['string'],
          summaryRating: 4.8,
          distance: 'string',
          totalReviews: 120,
          priceMinimum: 'string',
          emoji: 'string',
          emojiColor: 'red|blue|green|yellow|purple',
          isVerification: 'Y|N',
          createdAt: 'string',
          updatedAt: 'string',
        },
      },
    },
  })
  @ApiCommonErrors()
  findOne(@Param('id') id: string) {
    return this.servicesService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update service' })
  @ApiBody({ type: UpdateServiceDto })
  @ApiResponse({
    status: 200,
    description: 'Service updated',
    schema: { example: { data: 'string', status: 200 } },
  })
  @ApiCommonErrors()
  update(@Param('id') id: string, @Body() updateServiceDto: UpdateServiceDto) {
    return this.servicesService.update(id, updateServiceDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete service' })
  @ApiResponse({
    status: 200,
    description: 'Service deleted',
    schema: {
      example: { message: 'Service deleted successfully', status: 200 },
    },
  })
  @ApiCommonErrors()
  remove(@Param('id') id: string) {
    return this.servicesService.remove(id);
  }
}
