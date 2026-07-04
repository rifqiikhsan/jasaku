import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
} from 'typeorm';
import { UserRole } from './user-role.enum';
import { randomBytes } from 'crypto';

@Entity('users')
export class User {
  @PrimaryColumn({ type: 'varchar' })
  id!: string;

  @Column({ })
  fullName!: string;

  @Column({ unique: true, nullable: true })
  email!: string;

  @Column({ unique: true, nullable: true })
  phone!: string;

  @Column()
  password!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.CUSTOMER,
  })
  role!: UserRole;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @BeforeInsert()
  generateId() {
    this.id = randomBytes(16).toString('hex');
  }
}
