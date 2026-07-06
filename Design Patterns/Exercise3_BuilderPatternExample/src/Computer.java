public class Computer {
    private final String cpu;
    private final String ram;
    private final String storage;
    private final String gpu;

    private Computer(Builder builder) {
        this.cpu = builder.cpu;
        this.ram = builder.ram;
        this.storage = builder.storage;
        this.gpu = builder.gpu;
    }

    @Override
    public String toString() {
        return "Computer [CPU=" + cpu + ", RAM=" + ram + ", Storage=" + storage + ", GPU=" + gpu + "]";
    }

    public static class Builder {
        private String cpu;
        private String ram;
        private String storage;
        private String gpu;

        public Builder setCPU(String cpu) {
            this.cpu = cpu;
            return this;
        }

        public Builder setRAM(String ram) {
            this.ram = ram;
            return this;
        }

        public Builder setStorage(String storage) {
            this.storage = storage;
            return this;
        }

        public Builder setGPU(String gpu) {
            this.gpu = gpu;
            return this;
        }

        public Computer build() {
            return new Computer(this);
        }
    }
}
