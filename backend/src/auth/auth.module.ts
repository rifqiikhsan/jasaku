import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

import { User } from '../users/entities/user.entity';
import { JwtStrategy } from './strategies/jwt.strategy';
const JWT_SECRET = process.env.JWT_SECRET;

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    JwtModule.register({
      secret: JWT_SECRET ?? 'secret',
      signOptions: {
        expiresIn: (process.env.JWT_EXPIRES_IN ?? '7d') as any,
      },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
})
export class AuthModule {}
