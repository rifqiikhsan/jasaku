import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { Service } from './entities/service.entity';
import { Category } from '../categories/entities/category.entity';

@Injectable()
export class ServicesService {
  constructor(
    @InjectRepository(Service)
    private readonly serviceRepo: Repository<Service>,
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) {}

  private async validateCategoryIds(categoryIds?: string[]) {
    if (!categoryIds || categoryIds.length === 0) {
      return;
    }

    const categories = await this.categoryRepo.find({
      where: categoryIds.map((id) => ({ id })),
    });

    if (categories.length !== categoryIds.length) {
      throw new BadRequestException('One or more category ids are invalid');
    }
  }

  async create(createServiceDto: CreateServiceDto) {
    const existingService = await this.serviceRepo.findOne({
      where: { serviceName: createServiceDto.serviceName },
    });

    if (existingService) {
      throw new BadRequestException(
        'Service with the same name already exists',
      );
    }

    await this.validateCategoryIds(createServiceDto.category);

    const service = this.serviceRepo.create(createServiceDto);
    const result = await this.serviceRepo.save(service);

    return {
      status: 201,
      data: result.id.toString(),
    };
  }

  async findAll() {
    const services = await this.serviceRepo.find();

    const data = await Promise.all(
      services.map(async (service) => {
        const categoryIds = service.category ?? [];
        const categories = categoryIds.length
          ? await this.categoryRepo.find({
              where: categoryIds.map((id) => ({ id })),
            })
          : [];

        return {
          ...service,
          category: categories.map(({ id, catDesc }) => ({ id, catDesc })),
        };
      }),
    );

    return {
      status: 200,
      data,
    };
  }

  async findOne(id: string) {
    const service = await this.serviceRepo.findOne({ where: { id } });

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    const categoryIds = service.category ?? [];
    const categories = categoryIds.length
      ? await this.categoryRepo.find({
          where: categoryIds.map((categoryId) => ({ id: categoryId })),
        })
      : [];

    return {
      status: 200,
      data: {
        ...service,
        category: categories.map(({ id, catDesc }) => ({ id, catDesc })),
      },
    };
  }

  async update(id: string, updateServiceDto: UpdateServiceDto) {
    const service = await this.serviceRepo.findOne({ where: { id } });

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    if (updateServiceDto.category) {
      await this.validateCategoryIds(updateServiceDto.category);
    }

    await this.serviceRepo.update(id, updateServiceDto);

    return {
      status: 200,
      data: id,
    };
  }

  async remove(id: string) {
    const service = await this.serviceRepo.findOne({ where: { id } });

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    await this.serviceRepo.delete(id);

    return {
      status: 200,
      message: 'Service deleted',
    };
  }
}
