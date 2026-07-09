import { randomBytes } from 'crypto';
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BeforeInsert,
} from 'typeorm';

export enum ServiceEmojiColor {
  RED = 'red',
  BLUE = 'blue',
  GREEN = 'green',
  YELLOW = 'yellow',
  PURPLE = 'purple',
}

@Entity('services')
export class Service {
  @PrimaryColumn({ type: 'varchar' })
  id!: string;

  @Column()
  serviceName!: string;

  @Column('simple-array')
  category!: string[];

  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  summaryRating!: number;

  @Column()
  distance!: string;

  @Column({ type: 'int', default: 0 })
  totalReviews!: number;

  @Column()
  priceMinimum!: string;

  @Column()
  emoji!: string;

  @Column({
    type: 'enum',
    enum: ServiceEmojiColor,
    default: ServiceEmojiColor.RED,
  })
  emojiColor!: ServiceEmojiColor;

  @Column({ type: 'char', length: 1, default: 'N' })
  isVerification!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @BeforeInsert()
  generateId() {
    this.id = randomBytes(16).toString('hex');
  }
}
