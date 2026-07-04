import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';

import { User } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UserMapper } from '../users/mapper/user.mapper';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const existingUser = await this.userRepository.findOne({
  where: [
    { email: dto.email },
    { phone: dto.phone },
  ],
});

    if (existingUser) {
      throw new BadRequestException('Email or phone already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = this.userRepository.create({
      fullName: dto.fullName,
      email: dto.email,
      phone: dto.phone,
      password: hashedPassword,
      role: dto.role,
    });

    const result = await this.userRepository.save(user);

    return {
      status: 201,
      data: result.id.toString(),
    };
  }

  async login(dto: LoginDto) {
  const user = await this.userRepository.findOne({
    where: { email: dto.email },
  });

  if (!user) {
    throw new UnauthorizedException('Email not found');
  }

  if (user.role !== dto.role) {
    throw new UnauthorizedException(
      `Account is not registered as ${dto.role}`,
    );
  }

  const isMatch = await bcrypt.compare(
    dto.password,
    user.password,
  );

  if (!isMatch) {
    throw new UnauthorizedException('Wrong password');
  }

  const token = this.jwtService.sign({
    sub: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    statusCode: 200,
    message: 'Login successful',
    data: {
      accessToken: token,
      user: UserMapper.toResponse(user),
    },
  };
}
}
