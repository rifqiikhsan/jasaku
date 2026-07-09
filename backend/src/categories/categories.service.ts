import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm/browser/repository/Repository.js';
import { Category } from './entities/category.entity';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) {}

  async create(createCategoryDto: CreateCategoryDto) {
    const existingCategory = await this.categoryRepo.findOne({
      where: { catDesc: createCategoryDto.catDesc },
    });

    if (existingCategory) {
      throw new BadRequestException(
        'Category with the same description already exists',
      );
    }
    const category = this.categoryRepo.create(createCategoryDto);

    const result = await this.categoryRepo.save(category);
    return {
      status: 201,
      data: result.id.toString(),
    };
  }

  async findAll() {
    const categories = await this.categoryRepo.find();
    return {
      status: 200,
      data: categories,
    };
  }

  async findOne(id: string) {
    const category = await this.categoryRepo.findOne({ where: { id } });
    if (!category) {
      throw new BadRequestException('Category not found');
    }
    return {
      status: 200,
      data: category,
    };
  }

  async update(id: string, updateCategoryDto: UpdateCategoryDto) {
    const category = await this.categoryRepo.findOne({ where: { id } });
    if (!category) {
      throw new BadRequestException('Category not found');
    }
    await this.categoryRepo.update(id, updateCategoryDto);
    return {
      status: 200,
      message: 'Category updated successfully',
    };
  }

  async remove(id: string) {
    const category = await this.categoryRepo.findOne({ where: { id } });
    if (!category) {
      throw new BadRequestException('Category not found');
    }
    await this.categoryRepo.delete(id);
    return {
      status: 200,
      message: 'Category removed successfully',
    };
  }
}
