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
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
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
@Controller('categories')
@ApiTags('Categories')
@ApiBearerAuth()
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Post()
  @ApiOperation({ summary: 'Create Category' })
  @ApiBody({ type: CreateCategoryDto })
  @ApiResponse({
    status: 201,
    description: 'Category created successfully',
    schema: { example: { data: 'string', status: 201 } },
  })
  @ApiCommonErrors()
  create(@Body() createCategoryDto: CreateCategoryDto) {
    return this.categoriesService.create(createCategoryDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all categories' })
  @ApiResponse({
    status: 200,
    description: 'List of Categories',
    schema: {
      example: {
        status: 200,
        data: [
          {
            id: 'string',
            catDesc: 'string',
            catEmoji: 'string',
            catColor: 'string',
            createdAt: 'string',
            updatedAt: 'string',
          },
        ],
      },
    },
  })
  @ApiCommonErrors()
  findAll() {
    return this.categoriesService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get category by id' })
  @ApiResponse({
    status: 200,
    description: 'Category detail',
    schema: {
      example: {
        status: 200,
        data: {
          id: 'string',
          catDesc: 'string',
          catEmoji: 'string',
          catColor: 'string',
          createdAt: 'string',
          updatedAt: 'string',
        },
      },
    },
  })
  @ApiCommonErrors()
  findOne(@Param('id') id: string) {
    return this.categoriesService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update category' })
  @ApiBody({ type: UpdateCategoryDto })
  @ApiResponse({
    status: 200,
    description: 'Category updated',
    schema: { example: { data: 'string', status: 200 } },
  })
  update(
    @Param('id') id: string,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ) {
    return this.categoriesService.update(id, updateCategoryDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete category' })
  @ApiResponse({
    status: 200,
    description: 'Category deleted',
    schema: {
      example: { message: 'Category deleted successfully', status: 200 },
    },
  })
  remove(@Param('id') id: string) {
    return this.categoriesService.remove(id);
  }
}
