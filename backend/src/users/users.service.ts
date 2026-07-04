import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserMapper } from './mapper/user.mapper';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async create(dto: CreateUserDto) {
    const existing = await this.userRepo.findOne({
      where: [
        { email: dto.email },
        { phone: dto.phone },
      ],
    });

    if (existing) {
      throw new BadRequestException('Email or phone already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = this.userRepo.create({
      ...dto,
      password: hashedPassword,
    });

    const result = await this.userRepo.save(user);

    return {
      status: 201,
      data: result.id.toString(),
    };
  }

  async findAll() {
    const users = await this.userRepo.find();

    return {
      status: 200,
      data: users.map((user) => UserMapper.toResponse(user)),
    };
  }

  async findOne(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });

    if (!user) throw new NotFoundException('User not found');

    return {
      status: 200,
      data: UserMapper.toResponse(user),
    };
  }

  async update(id: string, dto: UpdateUserDto) {
    const user = await this.userRepo.findOne({ where: { id } });

    if (!user) throw new NotFoundException('User not found');

    const result = await this.userRepo.update(id, { ...dto });

    return {
      status: 200,
      data: id,
    };
  }

  async remove(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });

    if (!user) throw new NotFoundException('User not found');

    await this.userRepo.delete(id);

    return {
      status: 200,
      message: 'User deleted',
    };
  }
}
